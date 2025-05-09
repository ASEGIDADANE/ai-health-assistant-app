import { Request, Response, NextFunction } from "express";
import dotenv from "dotenv";
import {
    GoogleGenerativeAI,
    HarmCategory,
    HarmBlockThreshold,
    Content
  } from "@google/generative-ai"; // ✅ This is correct
import { Chat } from '../models/Chat';

dotenv.config();

const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new Error("API_KEY is not defined in the environment variables");
}
const genAI = new GoogleGenerativeAI(apiKey); 


const modelId = "gemini-1.5-flash"; 
const model = genAI.getGenerativeModel({
  model: modelId,
  safetySettings: [
    {
      category: HarmCategory.HARM_CATEGORY_HARASSMENT,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
    {
      category: HarmCategory.HARM_CATEGORY_HATE_SPEECH,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
    {
      category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
    {
      category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT,
      threshold: HarmBlockThreshold.BLOCK_MEDIUM_AND_ABOVE,
    },
  ],
});

export const generateResponse = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { prompt, userId } = req.body;

        if (!prompt || typeof prompt !== "string") {
            return res
                .status(400)
                .json({ message: "Prompt is required and must be a string." });
        }

        if (!userId) {
            return res
                .status(400)
                .json({ message: "userId is required." });
        }

        // Get chat history from MongoDB
        let chat = await Chat.findOne({ userId });
        if (!chat) {
            chat = new Chat({ userId, messages: [] });
        }

        // Convert MongoDB messages to Gemini format
        const historyForChat: Content[] = chat.messages.map(msg => ({
            role: msg.role,
            parts: [{ text: msg.content }]
        }));

        const chatSession = model.startChat({
            history: historyForChat,
            generationConfig: {
                maxOutputTokens: 100,
            },
        });

        const result = await chatSession.sendMessage(prompt);
        const response = result.response;

        if (!response || !response.candidates || response.candidates.length === 0) {
            let message = "No response from model.";
            if (response?.promptFeedback?.blockReason) {
                message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
                if (response.promptFeedback.blockReasonMessage) {
                    message += ` Message: ${response.promptFeedback.blockReasonMessage}`;
                }
            }
            console.error("Gemini API Error:", message, response?.promptFeedback);
            return res.status(500).json({ message });
        }

        const responseText = await response.text();

        // Save both user message and model response to MongoDB
        chat.messages.push(
            { role: 'user', content: prompt },
            { role: 'model', content: responseText }
        );

        // Keep only last 20 messages
        if (chat.messages.length > 20) {
          await Chat.updateOne(
              { _id: chat._id },
              { $set: { messages: chat.messages.slice(-20) } }
          );
      }

        await chat.save();

        res.status(200).json({ response: responseText });
    } catch (err) {
        console.error("Error in generateResponse:", err);
        next(err);
    }
};

export const generalChat = async (req: Request, res: Response, next: NextFunction) => {
    try {
        const { prompt } = req.body;
        const chatSession = model.startChat({
            history: [],
            generationConfig: {
                maxOutputTokens: 100,
            }
        });
        const result = await chatSession.sendMessage(prompt);
        const response = result.response;

        if (!response || !response.candidates || response.candidates.length === 0) {
            let message = "No response from model.";
            if (response?.promptFeedback?.blockReason) {
                message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
            }
        }
        const responseText = await response.text();
        res.status(200).json({ response: responseText });
    } catch (err) {
        console.error("Error in generalChat:", err);
        next(err);
    }
}
// Add new endpoint to get chat history
export const getChatHistory = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { userId } = req.params;

        const chat = await Chat.findOne({ userId });
        if (!chat) {
            return res.status(200).json({ messages: [] });
        }

        res.status(200).json({ messages: chat.messages });
    } catch (err) {
        console.error("Error in getChatHistory:", err);
        next(err);
    }
};


// endpoint for symptom check user send list of symptoms and get response from model
export const symptomCheck = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { symptoms } = req.body;
        
        if (!symptoms || typeof symptoms !== "string") {
            return res
                .status(400)
                .json({ message: "Symptoms are required and must be a string." });
        }

        const prompt = `Based on the following symptoms: ${symptoms} please give me a list of possible conditions.`;
        const chatSession = model.startChat({
            history: [],
            generationConfig: {
                maxOutputTokens: 100,
            }
        });
        const result = await chatSession.sendMessage(prompt);
        const response = result.response;

        if (!response || !response.candidates || response.candidates.length === 0) {
            let message = "No response from model.";
            if (response?.promptFeedback?.blockReason) {
                message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
                if (response.promptFeedback.blockReasonMessage) {
                    message += ` Message: ${response.promptFeedback.blockReasonMessage}`;
                }
            }
            console.error("Gemini API Error:", message, response?.promptFeedback);
            return res.status(500).json({ message });
        }

        const responseText = await response.text();
        res.status(200).json({ response: responseText });
    }
    catch (err) {
        console.error("Error in symptomCheck:", err);
        next(err);
    }
};

// endpoint for first aid user send conditon or (burn, cut, etc) and model give response step by step to do first aid or give guidnce 
export const firstAid = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { caseType } = req.body;
        if (!caseType || typeof caseType !== "string") {
            return res
                .status(400)
                .json({ message: "Case type is required and must be a string." });
        }
        const prompt = `Based on the following case type: ${caseType} please give me a step by step guide to do first aid`;
        const chatSession = model.startChat({
            history: [],
            generationConfig: {
                maxOutputTokens: 100,
            }
        });
        const result = await chatSession.sendMessage(prompt);
        const response = result.response;
        if (!response || !response.candidates || response.candidates.length === 0) {
            let message = "No response from model.";
            if (response?.promptFeedback?.blockReason) {
                message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
                if (response.promptFeedback.blockReasonMessage) {
                    message += ` Message: ${response.promptFeedback.blockReasonMessage}`;
                }
            }
            console.error("Gemini API Error:", message, response?.promptFeedback);
            return res.status(500).json({ message });
        }
        const responseText = await response.text();
        res.status(200).json({ response: responseText });
    }
    catch (err) {
        console.error("Error in firstAid:", err);
        next(err);
    }
};

