import mongoose from 'mongoose';

const connectDB = async (): Promise<void> => {
  try {
    await mongoose.connect(process.env.CONNECTION_STRING as string, {
    });
    console.log("✅ MongoDB Connected", mongoose.connection.host, mongoose.connection.name);
  } catch (error) {
    console.error("❌ MongoDB Connection Failed:", error);
    process.exit(1);
  }
};

export default connectDB;