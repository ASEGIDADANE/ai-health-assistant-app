
import { Request, Response } from 'express';
import HealthProfile, { healthProfileValidationSchema, IHealthProfileInput } from '../models/healthprofileModel';
import User from '../models/userModel'; 



export const createOrUpdateHealthProfile = async (req: Request, res: Response) : Promise<void> => {
  try {
    if (!req.user || !req.user.id) {
      res.status(401).json({ message: "Unauthorized: User not authenticated" });
        return;
    } 
    const userId = req.user.id;

    const validationResult = healthProfileValidationSchema.safeParse(req.body);

    if (!validationResult.success) {
      res.status(400).json({ errors: validationResult.error.flatten().fieldErrors });
      return;
    }

    const profileData: IHealthProfileInput = validationResult.data;

    const healthProfile = await HealthProfile.findOneAndUpdate(
      { user: userId },
      { ...profileData, user: userId },
      { new: true, upsert: true, runValidators: true } 
    );

    await User.findByIdAndUpdate(userId, { profileCompleted: true });

    res.status(200).json(healthProfile);
  } catch (error) {
    console.error("Error creating/updating health profile:", error);
    res.status(500).json({ message: "Server error" });
  }
};


export const getHealthProfile = async (req: Request, res: Response): Promise<void> => {
    try {
        if (!req.user || !req.user.id) {
        res.status(401).json({ message: "Unauthorized: User not authenticated" });
        return;
        } 
        const userId = req.user.id;
    
        const healthProfile = await HealthProfile.findOne({ user: userId });
    
        if (!healthProfile) {
        res.status(404).json({ message: "Health profile not found" });
        return;
        }
    
        res.status(200).json(healthProfile);
    } catch (error) {
        console.error("Error fetching health profile:", error);
        res.status(500).json({ message: "Server error" });
    }
    }

    


