import express, { RequestHandler } from 'express';
import {
     generateResponse, 
     symptomCheck,
    generalChat
    } from '../controllers/aiController';
import { authenticateUser } from "../middleWares/authMiddleWare";


const router = express.Router();

// POST endpoint for generating AI responses 

router.post('/personalized/chat', generateResponse as RequestHandler);

router.post('/general/symptom-check', authenticateUser, symptomCheck as RequestHandler);
router.post('/general/chat', authenticateUser, generalChat as RequestHandler);

export default router;
