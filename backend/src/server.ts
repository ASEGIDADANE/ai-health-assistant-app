import express from 'express';
import dotenv from 'dotenv';
import cors from 'cors';
dotenv.config();
import connectDB from './config/db';
import authRoutes from './routes/authRoutes';
import healthProfileRoutes from './routes/healthProfileRoutes';
import aiRoutes from './routes/aiRoutes';
import healthRoutes from './routes/healthRoutes'; // Import the router


const app = express();

app.use(cors());


//  connect to database

connectDB();


// middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));










// routes
app.use('/api/healthsnippets', healthRoutes);
app.use('/api/auth',authRoutes );
app.use('/api/health',healthProfileRoutes );
app.use('/api/ai',aiRoutes);
// healthsnippets/snippet
app.listen(process.env.PORT, () => {
  console.log(`Server is running on port ${process.env.PORT}`);
}
);
