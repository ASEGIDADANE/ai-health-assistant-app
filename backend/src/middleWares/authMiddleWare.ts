// import jwt from "jsonwebtoken";
// import { NextFunction, Request, Response } from "express";
// import dotenv from "dotenv";
// dotenv.config();
// import User from "../models/userModel";


// declare global {
//   namespace Express {
//     interface Request {
//       user?: {
//         id: string;
//         email: string;
//         userType: string;
//         profileCompleted: boolean;
//       };
//     }
//   }
// }

// export const authenticateUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
//   const authHeader = req.headers.authorization;

  
//   if (!authHeader || !authHeader.startsWith("Bearer ")) {
//     res.status(401).json({ message: "Unauthorized: No token provided" });
//     return;
//   }

//   const token = authHeader.split(" ")[1];

//   try {
   
//     const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as { id: string };

//     const user = await User.findById(decoded.id).select("-password");
//     if (!user) {
//       res.status(401).json({ message: "Unauthorized: User not found" });
//       return;
//     }

  
//     req.user = {
//       id: user.id.toString(),
//       email: user.email,
//       userType: user.userType,
//       profileCompleted: user.profileCompleted,
//     };

//     // Proceed to the next middleware or route handler
//     next();
//   } catch (error) {
//     console.error("Error in authenticateUser:", error);
//     res.status(401).json({ message: "Unauthorized: Invalid token" });
//   }
// };


import jwt from "jsonwebtoken";
import { NextFunction, Request, Response } from "express";
import dotenv from "dotenv";
dotenv.config();
import User from "../models/userModel";


declare global {
  namespace Express {
    interface Request {
      user?: {
        id: string;
        email: string;
        userType: string;
        profileCompleted: boolean;
      };
    }
  }
}

export const authenticateUser = async (req: Request, res: Response, next: NextFunction): Promise<void> => {
  const authHeader = req.headers.authorization;

  
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    res.status(401).json({ message: "Unauthorized: No token provided" });
    return;
  }

  const token = authHeader.split(" ")[1];

  try {
   
    // Correctly type the decoded payload and access 'userId'
    const decoded = jwt.verify(token, process.env.JWT_SECRET as string) as { userId: string; iat: number; exp: number };

    // Use decoded.userId to find the user
    const user = await User.findById(decoded.userId).select("-password");
    if (!user) {
      res.status(401).json({ message: "Unauthorized: User not found" });
      return;
    }

  
    req.user = {
      id: user.id.toString(), // user.id here is correct as it comes from the Mongoose User model instance
      email: user.email,
      userType: user.userType,
      profileCompleted: user.profileCompleted,
    };

    // Proceed to the next middleware or route handler
    next();
  } catch (error) {
    console.error("Error in authenticateUser:", error);
    // Handle different JWT errors specifically if needed (e.g., TokenExpiredError)
    if (error instanceof jwt.TokenExpiredError) {
        res.status(401).json({ message: "Unauthorized: Token expired" });
    } else if (error instanceof jwt.JsonWebTokenError) {
        res.status(401).json({ message: "Unauthorized: Invalid token" });
    } else {
        res.status(401).json({ message: "Unauthorized: Invalid token" });
    }
  }
};