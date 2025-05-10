import  Express  from "express";
import { fetchNearbyServices } from "../controllers/nearbyControllers";
import { authenticateUser } from "../middleWares/authMiddleWare";



const router =  Express.Router();

router.get("/nearby", authenticateUser, fetchNearbyServices);

export default router;