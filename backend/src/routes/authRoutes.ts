import express, { Request, Response } from 'express';
import { authenticateUser } from '../middleWares/authMiddleWare';
import { registerUser,loginUser ,logout} from '../controllers/authController';


const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/logout',logout) 

export default router;
