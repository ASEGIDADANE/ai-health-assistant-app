import express from 'express';

import { authenticateUser } from '../middleWares/authMiddleWare';
import { createOrUpdateHealthProfile,getHealthProfile } from '../controllers/healthprofileControllers';
import { healthProfileValidationSchema } from '../models/healthprofileModel';

const router = express.Router();

router.post(
  '/createUpdate',
    authenticateUser,createOrUpdateHealthProfile
);
router.get(
  '/getHealthProfile',
    authenticateUser,getHealthProfile
);

    
export default router;