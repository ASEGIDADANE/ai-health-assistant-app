import { Request, Response, NextFunction } from 'express';
// import { userLoginSchemaZod, userValidationSchema } from "../models/userModel";
// import User from "../models/userModel";
import User from "../models/userModel";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { authService } from '../services/authService';

import { z } from "zod";

export const register = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { email, password, name } = req.body;

        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        const user = await User.create({
            email,
            password: hashedPassword,
            name
        });

        const { accessToken, refreshToken } = authService.generateTokens(user._id);
        await authService.saveRefreshToken(user._id, refreshToken);

        res.status(201).json({
            message: 'User registered successfully',
            accessToke
            refreshToken
        });
    } catch (error) {
        next(error);
    }
};

export const login = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { email, password } = req.body;

        const user = await User.findOne({ email });
        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const isValidPassword = await bcrypt.compare(password, user.password);
        if (!isValidPassword) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const { accessToken, refreshToken } = authService.generateTokens(user._id);
        await authService.saveRefreshToken(user._id, refreshToken);

        res.json({
            message: 'Login successful',
            accessToken,
            refreshToken
        });
    } catch (error) {
        next(error);
    }
};

export const refreshToken = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { refreshToken } = req.body;

        if (!refreshToken) {
            return res.status(400).json({ message: 'Refresh token is required' });
        }

        const { accessToken } = await authService.refreshAccessToken(refreshToken);
        res.json({ accessToken });
    } catch (error) {
        next(error);
    }
};

export const logout = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const userId = req.user?.userId; // Assuming you have user info in request
        await authService.logout(userId);
        res.json({ message: 'Logged out successfully' });
    } catch (error) {
        next(error);
    }
};