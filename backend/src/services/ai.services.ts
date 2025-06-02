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
                maxOutputTokens: 1000,
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


    // export const generalChat = async (prompt: string): Promise<string> =>{

    //     const chatSession = model.startChat({
    //         history: [],
    //         generationConfig: {
    //             maxOutputTokens: 500,
    //         }
    //     });
    //     const promptText =  `
    //     // when responding please be as concise as possible, don't repeat the question, and don't add any extra information.
    //     // and try to answer the question in simple way and make it clear
    //      Offer detailed suggestions, potential next steps, or relevant considerations.
    //     ${prompt}`;

        
    //     const result = await chatSession.sendMessage(promptText);
    //     const response = result.response;

    //     if (!response || !response.candidates || response.candidates.length === 0) {
    //         let message = "No response from model.";
    //         if (response?.promptFeedback?.blockReason) {
    //             message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
    //         }
    //         throw new Error(message);
    //     }

    //     return await response.text();
    // }

    // ...existing code...
    export const generalChat = async (prompt: string): Promise<string> =>{

        const chatSession = model.startChat({
            history: [], // For general chat, history might be empty if each query is independent
            generationConfig: {
                maxOutputTokens: 1000, // Increased to allow for more detailed and longer responses
            }
        });

        // This is the detailed system prompt that instructs the AI
            const systemAndUserPrompt =  `
                    You are an AI Medical Assistant. Your primary purpose is to provide comprehensive, detailed, and helpful information regarding medical-related questions. Your responses should be educational, supportive, and easy to understand.

                    When addressing the user's query, please adhere to the following guidelines:

                    1.  **Thorough Explanations:**
                        *   Clearly explain any medical terms, conditions, symptoms, or procedures mentioned in the user's query or in your response.
                        *   Break down complex medical information into simpler, understandable parts.

                    2.  **Detailed Suggestions & Next Steps:**
                        *   Offer specific and actionable suggestions relevant to the query.
                        *   Discuss potential next steps the user might consider, such as questions to ask their doctor, types of medical specialists that might be relevant, or general types of diagnostic tests (always emphasizing that a healthcare professional must make specific recommendations).

                    3.  **Recovery Methods & Lifestyle Adjustments:**
                        *   If applicable to the query, discuss potential recovery methods, self-care techniques, and beneficial lifestyle adjustments.
                        *   This can include general advice on diet, exercise, stress management, and other non-pharmacological approaches that are commonly associated with the condition or query.

                    4.  **Comprehensive Information & Deeper Understanding:**
                        *   Include any other pertinent information that can help the user gain a deeper and broader understanding of the topic.
                        *   This might involve discussing common misconceptions, the importance of early detection if relevant, or pointing towards the types of information they might find from reputable medical organizations.

                    5.  **Clarity and Empathy:**
                        *   Present all information in a clear, simple, and empathetic manner.
                        *   Avoid overly technical jargon where possible; if technical terms are necessary, explain them.

                    6.  **Conciseness within Detail:**
                        *   While aiming for comprehensive and detailed responses, strive for conciseness where appropriate. Avoid unnecessary repetition or redundant information. Ensure the core message is clear.

                    **User's Query:**
                    ${prompt}

                    **CRITICAL REMINDER (This entire section MUST be included at the end of EVERY response you generate):**
                    ---
                    **Important Disclaimer:** The information provided above is for general informational and educational purposes only, and it does not constitute medical advice. It is essential to consult with a qualified healthcare professional (such as a doctor or other registered health provider) for any health concerns or before making any decisions related to your health or treatment. This information should not be used as a substitute for professional medical diagnosis, advice, or treatment. Self-treating based on this information can be dangerous. Always seek the guidance of your doctor or other qualified health professional with any questions you may have regarding a medical condition. Never disregard the advice of a medical professional, or delay in seeking it because of something you have read or interpreted from this AI assistant.
                    ---
                            `;

        
        const result = await chatSession.sendMessage(systemAndUserPrompt); // Send the combined system and user prompt
        const response = result.response;

        if (!response || !response.candidates || response.candidates.length === 0) {
            let message = "No response from model.";
            if (response?.promptFeedback?.blockReason) {
                message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
                if (response.promptFeedback.blockReasonMessage) { // Check if blockReasonMessage exists
                    message += ` Message: ${response.promptFeedback.blockReasonMessage}`;
                }
            }
            throw new Error(message);
        }

        return await response.text();
    }
// ...existing code...

    // export const symptomCheck = async (symptoms: string,userId: string ): Promise<string> => {
    // //     const prompt = `
    // // You are a medical assistant. Provide a simple numbered list (1-5) of possible medical conditions related to the following symptoms, without descriptions.
    
    // // Symptoms: ${symptoms}
    
    // // Just list the condition names, nothing else.
    // // `;
    //                 const systemAndUserPrompt = `
    //             You are an AI Medical Assistant. Your role is to provide a list of potential medical conditions based on the symptoms provided by the user. This list is for informational purposes only and is not a diagnosis.

    //             User's Symptoms:
    //             ${symptoms}

    //             Based on these symptoms, please provide a list of possible medical conditions.
    //             Format your response exactly as follows:
    //             and does not include  any health profile information or any other user information.

    //             Possible causes include:

    //             Condition 1
    //             Condition 2
    //             Condition 3
    //             Condition 4
    //             Condition 5

    //             (List up to 5 common possibilities. Do not add any descriptions or extra text beyond the condition names in the list.)

    //             **CRITICAL REMINDER (This entire section MUST be included at the end of EVERY response you generate):**
    //             ---
    //             **Important Disclaimer:** The information provided above, including the list of possible conditions, is for general informational and educational purposes only, and it does not constitute a medical diagnosis or medical advice. Symptoms can be indicative of various conditions, and a proper diagnosis can only be made by a qualified healthcare professional after a thorough evaluation. It is essential to consult with a qualified healthcare provider (such as a doctor or other registered health provider) for any health concerns or before making any decisions related to your health or treatment. Do not rely on this list for self-diagnosis or treatment. Self-treating based on this information can be dangerous. Always seek the guidance of your doctor or other qualified health professional with any questions you may have regarding your symptoms or a medical condition.
    //             ---
    //             `;
    
    //     const chatSession = model.startChat({
    //         history: [],
    //         generationConfig: {
    //             maxOutputTokens: 100,
    //         },
    //     });
    
    //     const result = await chatSession.sendMessage(systemAndUserPrompt);
    //     const response = result.response;
    
    //     if (!response || !response.candidates || response.candidates.length === 0) {
    //         let message = "No response from model.";
    //         if (response?.promptFeedback?.blockReason) {
    //             message = `Request blocked due to ${response.promptFeedback.blockReason}.`;
    //             if (response.promptFeedback.blockReasonMessage) {
    //                 message += ` Message: ${response.promptFeedback.blockReasonMessage}`;
    //             }
    //         }
    //         throw new Error(message);
    //     }
    
    //     const rawText = await response.text();
    //     if (!rawText) {
    //         throw new Error("No text response from model.");
    //     }
    //     // Clean up: only keep numbered lines, remove stars, backslashes, and trim
    //     return rawText;
    //     // Return the raw text response directly
    // };
    
    export const symptomCheck = async (
        symptoms: string,
        userId: string
      ): Promise<string> => {
        const prompt = `
      You are a medical assistant. Based on the following symptoms, list ONLY five possible medical conditions. 
      Only output a numbered list like:
      
      1. Condition A  
      2. Condition B  
      3. Condition C  
      4. Condition D  
      5. Condition E  
      
      Do NOT include any disclaimers, explanations, or extra text.
      
      Symptoms: ${symptoms}
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
        if (!rawText) {
          throw new Error("No text response from model.");
        }
      
        // Keep only the condition names, remove "1. ", "2. ", etc.
        const cleanedList = rawText
          .split("\n")
          .map((line) => line.trim())
          .filter((line) => /^\d+\.\s*/.test(line))
          .map((line) => line.replace(/^\d+\.\s*/, "")) // Remove "1. ", "2. ", etc.
          .join("\n");
      
        return cleanedList;
      };
      