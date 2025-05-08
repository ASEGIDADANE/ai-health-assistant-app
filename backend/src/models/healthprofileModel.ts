import mongoose, { Schema, Document } from "mongoose";
import { z } from "zod"; // Import Zod


interface IHealthProfile extends Document {
  user: mongoose.Types.ObjectId;
  age: number;
  gender: "male" | "female" | "other";
  weight: number; 
  height: number; 
  medicalHistory: string[];
  lifestyle: {
    smoking: boolean;
    alcohol: boolean;
    exerciseFrequency: "none" | "rarely" | "regularly";
  };
}

// Mongoose Schema
const healthProfileSchema = new Schema<IHealthProfile>(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true, 
    },
    age: { type: Number, required: true, min: 0, max: 150 },
    gender: {
      type: String,
      enum: ["male", "female", "other"],
      required: true,
    },
    weight: { type: Number, required: true, min: 1, max: 250 }, 
    height: { type: Number, required: true, min: 1, max: 300 }, 
    medicalHistory: [{ type: String }],
    lifestyle: {
      smoking: { type: Boolean, required: true },
      alcohol: { type: Boolean, required: true },
      exerciseFrequency: {
        type: String,
        enum: ["none", "rarely", "regularly"],
        required: true,
      },
    },
  },
  {
    timestamps: true, 
  }
);


const healthProfileValidationSchema = z.object({

  age: z.number().int().min(0, "Age must be a positive number").max(150, "Age seems too high"),
  gender: z.enum(["male", "female", "other"]),
  weight: z.number().min(1, "Weight must be greater than 0").max(1000, "Weight seems too high"),
  height: z.number().min(1, "Height must be greater than 0").max(300, "Height seems too high"),
  medicalHistory: z.array(z.string().min(1, "Medical history item cannot be empty")).optional(),
  lifestyle: z.object({
    smoking: z.boolean(),
    alcohol: z.boolean(),
    exerciseFrequency: z.enum(["none", "rarely", "regularly"]),
  }),
});


type IHealthProfileInput = z.infer<typeof healthProfileValidationSchema>;

const HealthProfile = mongoose.model<IHealthProfile>(
  "HealthProfile",
  healthProfileSchema
);

export default HealthProfile;
export type { IHealthProfile, IHealthProfileInput };
export { healthProfileValidationSchema };