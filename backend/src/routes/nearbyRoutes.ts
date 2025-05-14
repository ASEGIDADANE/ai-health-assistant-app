import  Express  from "express";
import { authenticateUser } from "../middleWares/authMiddleWare";
import { nearbyPlacesController } from "../controllers/nearbyControllers";



const router =  Express.Router();

router.get("/nearby", nearbyPlacesController);

export default router;