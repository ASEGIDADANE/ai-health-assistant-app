import express, { RequestHandler } from 'express';
import {
     generateResponse, 
     getChatHistory,
     symptomCheck,
    generalChat
    } from '../controllers/aiController';
import { authenticateUser } from "../middleWares/authMiddleWare";


const router = express.Router();

// POST endpoint for generating AI responses 

router.post('/personalized/chat', authenticateUser, generateResponse as RequestHandler);
router.get('/personalized/chat/:userId', authenticateUser, getChatHistory as RequestHandler);

router.post('/general/symptom-check', symptomCheck as RequestHandler);
router.post('/general/chat', generalChat as RequestHandler);

export default router;
