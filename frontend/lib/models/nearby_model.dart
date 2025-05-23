import 'dart:convert';

class NearbyPlace {
    final String name;
    final String placeId;
    final Geometry geometry;
    final String vicinity;
    final String? amenity; // amenity can sometimes be null or missing

    NearbyPlace({
        required this.name,
        required this.placeId,
        required this.geometry,
        required this.vicinity,
        this.amenity,
    });

    factory NearbyPlace.fromJson(Map<String, dynamic> json) => NearbyPlace(
        name: json["name"],
        placeId: json["place_id"],
        geometry: Geometry.fromJson(json["geometry"]),
        vicinity: json["vicinity"],
        amenity: json["amenity"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "place_id": placeId,
        "geometry": geometry.toJson(),
        "vicinity": vicinity,
        "amenity": amenity,
    };
}

class Geometry {
    final Location location;

    Geometry({
        required this.location,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "location": location.toJson(),
    };
}

class Location {
    final double lat;
    final double lng;

    Location({
        required this.lat,
        required this.lng,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: (json["lat"] as num).toDouble(),
        lng: (json["lng"] as num).toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
    };
}