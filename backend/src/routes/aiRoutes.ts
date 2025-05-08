import express, { RequestHandler } from 'express';
import { generateResponse, getChatHistory } from '../controllers/aiController';

const router = express.Router();

// POST endpoint for generating AI responses
router.post('/generate', generateResponse as RequestHandler);
router.get('/history/:userId', getChatHistory as RequestHandler);

export default router;
