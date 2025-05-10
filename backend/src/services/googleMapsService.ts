import axios from 'axios';

interface PlaceResult {
  name: string;
  place_id: string;
  geometry: {
    location: {
      lat: number;
      lng: number;
    };
  };
  vicinity: string;
  [key: string]: any; 
}

export const getNearbyPlaces = async (
  lat: number,
  lng: number,
  type: string = 'hospital'
): Promise<PlaceResult[]> => {
  const apiKey = process.env.GOOGLE_MAPS_API_KEY;
  const radius = 5000; 

  if (!apiKey) {
    throw new Error('Google Maps API key is missing in environment variables');
  }

  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${lng}&radius=${radius}&type=${type}&key=${apiKey}`;

  const response = await axios.get(url);
  return response.data.results as PlaceResult[];
};
