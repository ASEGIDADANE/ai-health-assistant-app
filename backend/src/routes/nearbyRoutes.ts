import  Express  from "express";
import { authenticateUser } from "../middleWares/authMiddleWare";
import { nearbyPlacesController } from "../controllers/nearbyControllers";



const router =  Express.Router();

router.post("/nearby", nearbyPlacesController);

export default router;