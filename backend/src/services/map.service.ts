import axios from 'axios';

/**
 * Fetch nearby health facilities using Overpass API (OpenStreetMap)
 * @param lat Latitude of the user
 * @param lng Longitude of the user
 * @param type Facility type: hospital | clinic | pharmacy
 * @returns Array of nearby places
 */
export const getNearbyPlaces = async (
  lat: number,
  lng: number,
  type: string = 'hospital' // Can be hospital, clinic, pharmacy, or all
) => {
  const radius = 5000; // Search within 5 km radius
  const url = 'https://overpass-api.de/api/interpreter';

  // If 'type' is 'all', search all three types
  const amenityQuery =
    type === 'all' ? 'hospital|clinic|pharmacy' : type;

  const query = `
    [out:json];
    (
      node["amenity"~"${amenityQuery}"](around:${radius},${lat},${lng});
    );
    out body;
  `;

  try {
    const response = await axios.post(url, query, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    });

    const data = response.data as {
      elements: {
        tags: { name?: string; amenity: string };
        lat: number;
        lon: number;
      }[];
    };

    // Normalize and format results
    const results = data.elements.map((place, index) => ({
      name: place.tags.name || 'Unknown',
      place_id: `place_${index}`, // Generate a simple ID (OSM doesn’t give one)
      geometry: {
        location: {
          lat: place.lat,
          lng: place.lon,
        },
      },
      vicinity: 'Unknown vicinity', // You can enhance this later with reverse geocoding
      amenity: place.tags.amenity,
    }));

    return results;

  } catch (error) {
    console.error('Failed to fetch nearby places:', error);
    return []; // Return empty array on error
  }
};
