import {
    GoogleGenerativeAI,
    HarmCategory,
    HarmBlockThreshold,
    Content
} 
from '@google/generative-ai';
import { Chat } from '../models/Chat';
import dotenv from "dotenv";
import { getUserInfo } from "./user.services";
import HealthProfile from "../models/healthprofileModel";


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
        const userInfo = await getUserInfo(userId);
        console.log("User Info:", userInfo);
        //const userInfo =  await HealthProfile.findOne({ user: userId }).lean();

        
        let userProfileText = "please based on my current health profile please give me deep explanation like my body mass and other health related information.\n";

        if (userInfo && userInfo.healthProfile) {
            const p = userInfo.healthProfile;
            userProfileText += `\nHealth Profile:\n`;
            userProfileText += `- Age: ${p.age}\n`;
            userProfileText += `- Gender: ${p.gender}\n`;
            userProfileText += `- Weight: ${p.weight} kg\n`;
            userProfileText += `- Height: ${p.height} cm\n`;
            userProfileText += `- Medical History: ${p.medicalHistory?.length ? p.medicalHistory.join(", ") : "None"}\n`;
            userProfileText += `- Lifestyle:\n`;
            userProfileText += `  - Smoking: ${p.lifestyle.smoking ? "Yes" : "No"}\n`;
            userProfileText += `  - Alcohol: ${p.lifestyle.alcohol ? "Yes" : "No"}\n`;
            userProfileText += `  - Exercise Frequency: ${p.lifestyle.exerciseFrequency}\n`;
        } else {
            userProfileText += `\nUser has not completed their health profile yet.\n`;
        }
        
        prompt += userProfileText
        const promptText = `
        when responding please be as concise as possible, don't repeat the question, and don't add any extra information.
        . when you answer user questions, relate the answer with the user profile be 
        specific to th user profile and give short explanations.

        ${prompt}`;

        const historyForChat: Content[] = [
                ...chat.messages.map(msg => ({
                    role: msg.role,
                    parts: [{ text: msg.content }]
                }))
            ];


        const chatSession = model.startChat({
            history: historyForChat,

            generationConfig: {
                maxOutputTokens: 100,
            },
        });

        const result = await chatSession.sendMessage(promptText);
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
        const promptText =  `
        when responding please be as concise as possible, don't repeat the question, and don't add any extra information.
        and try to answer the question in simple way and make it clear
        ${prompt}`;
        
        const result = await chatSession.sendMessage(promptText);
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

    export const symptomCheck = async (symptoms: string, userId: string): Promise<string> => {
        const prompt = `
    You are a medical assistant. Provide a simple numbered list (1-5) of possible medical conditions related to the following symptoms, without descriptions.
    
    Symptoms: ${symptoms}
    
    Just list the condition names, nothing else.
    `;
    
        const chatSession = model.startChat({
            history: [],
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
    
        const rawText = await response.text();
    
        // Clean up: only keep numbered lines, remove stars, backslashes, and trim
        const cleanedList = rawText
            .split("\n")
            .map(line => line.trim())
            .filter(line => /^\d+\.\s*/.test(line)) // keep lines like "1. Disease"
            .map(line => line.replace(/^\d+\.\s*/, "")) // remove number prefix
            .join("\n");
    
        return cleanedList;
    };
    