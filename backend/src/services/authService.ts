import jwt from 'jsonwebtoken';
import { Token } from '../models/Token';
// import { User } from '../models/User';
import crypto from 'crypto';

class AuthService {
    private readonly JWT_SECRET = process.env.JWT_SECRET || 'your-secret-key';
    private readonly JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || 'your-refresh-secret-key';

    generateTokens(userId: string) {
        const accessToken = jwt.sign(
            { userId },
            this.JWT_SECRET,
            { expiresIn: '15m' }
        );

        const refreshToken = jwt.sign(
            { userId },
            this.JWT_REFRESH_SECRET,
            { expiresIn: '7d' }
        );

        return { accessToken, refreshToken };
    }

    async saveRefreshToken(userId: string, refreshToken: string) {
        await Token.findOneAndUpdate(
            { userId },
            { token: refreshToken },
            { upsert: true }
        );
    }

    async refreshAccessToken(refreshToken: string) {
        try {
            // Verify refresh token
            const decoded = jwt.verify(refreshToken, this.JWT_REFRESH_SECRET) as { userId: string };
            
            // Check if token exists in database
            const token = await Token.findOne({
                userId: decoded.userId,
                token: refreshToken
            });

            if (!token) {
                throw new Error('Invalid refresh token');
            }

            // Generate new access token
            const accessToken = jwt.sign(
                { userId: decoded.userId },
                this.JWT_SECRET,
                { expiresIn: '15m' }
            );

            return { accessToken };
        } catch (error) {
            throw new Error('Invalid refresh token');
        }
    }

    async logout(userId: string) {
        await Token.deleteOne({ userId });
    }
}

export const authService = new AuthService(); 