import {
    GoogleGenerativeAI,
    HarmCategory,
    HarmBlockThreshold,
    Content
} 
from '@google/generative-ai';
import { Chat } from '../models/Chat';
import dotenv from "dotenv";

dotenv.config();

const apiKey = process.env.API_KEY;
if (!apiKey) {
    throw new Error("API_KEY is not defined in the environment variables");
}

const genAI = new GoogleGenerativeAI(apiKey);
const modelId = "gemini-1.5-flash";

export interface IAiService {
    generateResponse(prompt: string, userId: string): Promise<string>;
    generalChat(prompt: string): Promise<string>;
    symptomCheck(symptoms: string): Promise<string>;
}

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



    export const generateResponse = async (prompt: string, userId: string): Promise<string> =>{
        let chat = await Chat.findOne({ userId });
        if (!chat) {
            chat = new Chat({ userId, messages: [] });
        }

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
            throw new Error(message);
        }

        const responseText = await response.text();

        chat.messages.push(
            { role: 'user', content: prompt },
            { role: 'model', content: responseText }
            
        );

        if (chat.messages.length > 20) {
            await Chat.updateOne(
                { _id: chat._id },
                { $set: { messages: chat.messages.slice(-20) } }
            );
        }

        await chat.save();
        return responseText;
    }

    export const generalChat = async (prompt: string): Promise<string> =>{

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
            throw new Error(message);
        }

        return await response.text();
    }

    export const symptomCheck = async (symptoms: string): Promise<string> => {
        const prompt = `IMPORTANT: The following is not medical advice. A doctor should be consulted for any health concerns. Based on the following symptoms: ${symptoms}, please give me a list of possible conditions. Always start your response with a clear disclaimer that this information is not a substitute for professional medical advice.`;
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
            throw new Error(message);
        }

        return await response.text();
    }
