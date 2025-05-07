import { NextFunction, Request, Response } from "express";
import dotenv from "dotenv";
dotenv.config();
import User from "../models/userModel";
import jwt from "jsonwebtoken";

export const checkRole = (allowedRoles: string[]) => {
  return async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      
      const authHeader = req.headers.authorization;
      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        res.status(401).json({ message: "Unauthorized: No token provided" });
        return;
      }

      const token = authHeader.split(" ")[1];

      
      const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as { id: string };

      
      const user = await User.findById(decoded.id);
      if (!user) {
        res.status(401).json({ message: "Unauthorized: User not found" });
        return;
      }

      if (!allowedRoles.includes(user.userType)) {
        res.status(403).json({ message: "Forbidden: You do not have access to this resource" });
        return;
      }

     
      req.user = {
        id: user.id.toString(),
        email: user.email,
        userType: user.userType,
        profileCompleted: user.profileCompleted,
      };

      next(); 
    } catch (error) {
      console.error("Error in checkRole middleware:", error);
      res.status(500).json({ message: "Internal server error" });
    }
  };
};