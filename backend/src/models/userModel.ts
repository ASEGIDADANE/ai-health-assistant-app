import mongoose, { Document, Schema } from "mongoose";
import zod from "zod";


interface IUser extends Document {
  email: string;
  password?: string;
  userType: "general" | "personalized";
  profileCompleted: boolean;
}


const userSchema: Schema = new mongoose.Schema(
  {
    email: {
      type: String,
      required: [true, "Email is required"],
      unique: true,
      lowercase: true,
    },
    password: {
      type: String,
      required: true,
    },
    userType: {
      type: String,
      enum: ["general", "personalized"],
      default: "general",
    },
    profileCompleted: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);





const userValidationSchema = zod.object({
  email: zod.string().email("Invalid email address"),
  password: zod.string().min(6, "Password must be at least 6 characters long"),
  userType: zod.enum(["general", "personalized"]).optional(),
  profileCompleted: zod.boolean().optional(),
});


const userLoginSchemaZod = zod.object({
  email: zod.string().email("Invalid email address"),
  password: zod.string().min(6, "Password must be at least 6 characters long"),
});


type IUserInput = zod.infer<typeof userValidationSchema>;
type IUserLoginInput = zod.infer<typeof userLoginSchemaZod>;


const User = mongoose.model<IUser>("User", userSchema);

export default User;
export { userValidationSchema, userLoginSchemaZod };
export type { IUser };
export { userSchema };
export type { IUserInput, IUserLoginInput };