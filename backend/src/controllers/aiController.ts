import { Request, Response, NextFunction } from "express";


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

        const responseText = await aiService.generateResponse(prompt, userId);
        res.status(200).json({ response: responseText });
    } catch (err) {
        console.error("Error in generateResponse:", err);
        next(err);
    }
};

export const generalChat = async (
    req: Request,
    res: Response,
    next: NextFunction
) => {
    try {
        const { prompt } = req.body;
        const responseText = await aiService.generalChat(prompt);
        res.status(200).json({ response: responseText });
    } catch (err) {
        console.error("Error in generalChat:", err);
        next(err);
    }
};


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

        const responseText = await aiService.symptomCheck(symptoms);
        res.status(200).json({ response: responseText });
    } catch (err) {
        console.error("Error in symptomCheck:", err);
        next(err);
    }
};