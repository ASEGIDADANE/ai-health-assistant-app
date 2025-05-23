// filepath: c:\Users\HP\Desktop\intagrate project\ai-health-assistant-app\frontend\lib\view_models\nearby_viewModel.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/services/nerbyService.dart';
import 'package:frontend/models/nearby_model.dart';

class NearbyViewModel extends ChangeNotifier {
  final nearbyService _nearbyService = nearbyService();

  bool _isLoading = false;
  String? _error;
  List<NearbyPlace> _nearbyPlaces = [];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<NearbyPlace> get nearbyPlaces => _nearbyPlaces;

  Future<void> fetchNearbyPlaces(String lat, String lng, String type) async {
    _isLoading = true;
    _error = null;
    _nearbyPlaces = []; 
    notifyListeners();

    try {
      final String jsonStringResponse = await _nearbyService.findnearbyService(lat, lng, type);
      
     
      final List<dynamic> decodedList = jsonDecode(jsonStringResponse);
      _nearbyPlaces = decodedList.map((item) => NearbyPlace.fromJson(item as Map<String, dynamic>)).toList();

    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _nearbyPlaces = []; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearData() {
    _nearbyPlaces = [];
    _error = null;
    _isLoading = false;
    notifyListeners(); 
  }
}