import HealthProfile from "../models/healthprofileModel";

export const getUserInfo = async (userId: string) => {
    const healthProfile = await HealthProfile.findOne({ user: userId }).lean();

    if (!healthProfile) {
        return { healthProfile: null };
    }

    return {
        healthProfile: {
            age: healthProfile.age,
            gender: healthProfile.gender,
            weight: healthProfile.weight,
            height: healthProfile.height,
            medicalHistory: healthProfile.medicalHistory,
            lifestyle: healthProfile.lifestyle,
        }
    };
};
