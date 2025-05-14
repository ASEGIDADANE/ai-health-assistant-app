import express from 'express';
import { register, login, refreshToken, logout } from '../controllers/authController';
import { authenticateUser } from '../middleWares/authMiddleWare';

const router = express.Router();

router.post('/register', register);
router.post('/login', login);
router.post('/refresh-token', refreshToken);
router.post('/logout', authenticateUser, logout);

export default router;
