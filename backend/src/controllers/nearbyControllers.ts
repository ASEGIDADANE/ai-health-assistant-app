import { Request, Response } from 'express';
import { getNearbyPlaces } from '../services/googleMapsService';

export const fetchNearbyServices = async (req: Request, res: Response): Promise<void> => {
  const { lat, lng, type } = req.query;

  if (!lat || !lng) {
    res.status(400).json({ message: 'Latitude and longitude are required.' });
    return;
  }

  try {
    const latitude = parseFloat(lat as string);
    const longitude = parseFloat(lng as string);
    const serviceType = (type as string) || 'hospital';

    const places = await getNearbyPlaces(latitude, longitude, serviceType);

    const formatted = places.map((place) => ({
      name: place.name,
      address: place.vicinity,
      type: serviceType,
      location: place.geometry.location,
      rating: place.rating,
      userRatingsTotal: place.user_ratings_total,
      contact: place.formatted_phone_number || null,
    }));

    res.status(200).json(formatted);
  } catch (error: any) {
    res.status(500).json({
      message: 'Failed to fetch nearby services',
      error: error.message || 'Unknown error',
    });
  }
};
