import { Request,Response } from "express";
import { userLoginSchemaZod,userValidationSchema } from "../models/userModel";
import User from "../models/userModel";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

import { z } from "zod";

export const registerUser = async (req: Request, res: Response): Promise<void> => {
    try {
     
      const { email, password } = userLoginSchemaZod.parse(req.body);
  
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        res.status(400).json({ message: "User already exists" });
        return;
      }
  
      
      const hashedPassword = await bcrypt.hash(password, 10);
  
      const newUser = new User({
        email,
        password: hashedPassword,
        userType: "general",
        profileCompleted: false,
      });
  
      
      await newUser.save();
  
     
      const token = jwt.sign(
        { id: newUser._id },
        process.env.JWT_SECRET as string,
        { expiresIn: "1d" }
      );
  
   
      res.status(201).json({
        token,
        user: {
          id: newUser._id,
          email: newUser.email,
          userType: newUser.userType,
          profileCompleted: newUser.profileCompleted,
        },
      });
    } catch (error) {
      
      if (error instanceof z.ZodError) {
        res.status(400).json({ message: error.errors });
        return;
      }
  
     
      console.error("Error in registerUser:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  export const loginUser = async (req: Request, res: Response): Promise<void> => {
    try {
      // Validate the request body using Zod
      const { email, password } = userLoginSchemaZod.parse(req.body);
  
      // Check if the user exists
      const user = await User.findOne({ email });
      if (!user) {
        res.status(400).json({ message: "Invalid email or password" });
        return;
      }
  
      // Check if the user has a password set (for local authentication)
      if (!user.password) {
        res.status(400).json({ message: "Password not set for this account" });
        return; 
      }
  
      // Validate the password
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        res.status(400).json({ message: "Invalid email or password" });
        return;
      }
  
      // Ensure JWT_SECRET is defined
      if (!process.env.JWT_SECRET) {
        console.error("JWT_SECRET is not defined in the environment variables");
        res.status(500).json({ message: "Internal server error" });
        return;
      }
  
      // Generate a JWT token
      const token = jwt.sign(
        { id: user._id },
        process.env.JWT_SECRET,
        { expiresIn: "1d" }
      );
  
      // Respond with the token and user data (excluding the password)
      res.status(200).json({
        token,
        user: {
          id: user._id,
          email: user.email,
          userType: user.userType,
          profileCompleted: user.profileCompleted,
        },
      });
    } catch (error) {
      // Handle validation errors from Zod
      if (error instanceof z.ZodError) {
        res.status(400).json({ message: error.errors });
        return;
      }
  
      // Handle other errors
      console.error("Error in loginUser:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };

  export const logout = async (req: Request, res: Response): Promise<void> => {
    const token = req.headers.authorization?.split(" ")[1];
    if (!token) {
        res.status(401).json({ message: "Unauthorized" });
        return;
    }
    const decoded:any = jwt.decode(token);
    const expire = new Date(decoded.exp * 1000);

    res.status(200).json({ message: "Logout successful" });
};