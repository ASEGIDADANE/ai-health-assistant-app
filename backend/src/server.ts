import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
dotenv.config();
import connectDB from './config/db';
import authRoutes from './routes/authRoutes';
import healthProfileRoutes from './routes/healthProfileRoutes';
import aiRoutes from './routes/aiRoutes';
import healthRoutes from './routes/healthRoutes';   
import nearbyRoutes from './routes/nearbyRoutes'; 

const app = express();
const PORT = process.env.PORT || 5000;

// connect to database
connectDB();

// middleware
app.use(cors({ 
  origin: '*',
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// routes
app.use('/api/auth', authRoutes);
app.use('/api/health', healthProfileRoutes);
app.use('/api/ai', aiRoutes);
app.use('/api/healthsnippets', healthRoutes); 
app.use('/api/nearby', nearbyRoutes);      

app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
});