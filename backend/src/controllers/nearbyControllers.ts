import { Request, Response } from 'express';
import { getNearbyPlaces } from '../services/map.service'; // adjust the path based on your project structure

export const nearbyPlacesController = async (req: Request, res: Response) => {
  const { lat, lng, type } = req.body;

  // Validate inputs
  if (!lat || !lng) {
    return res.status(400).json({ error: 'Latitude and longitude are required.' });
  }

  const latitude = parseFloat(lat as string);
  const longitude = parseFloat(lng as string);

  if (isNaN(latitude) || isNaN(longitude)) {
    return res.status(400).json({ error: 'Invalid latitude or longitude.' });
  }

  try {
    const places = await getNearbyPlaces(latitude, longitude, type as string);
    return res.json(places);
  } catch (error) {
    console.error('Error fetching nearby places:', error);
    return res.status(500).json({ error: 'Failed to fetch nearby places.' });
  }
};
