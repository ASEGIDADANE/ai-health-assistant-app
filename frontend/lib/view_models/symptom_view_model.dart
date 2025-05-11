import 'package:flutter/material.dart';
import 'package:frontend/services/symptom_checker_services.dart'; 

class SymptomViewModel extends ChangeNotifier {
  final symptomCheckService _service = symptomCheckService(); 

  bool _isLoading = false;
  String? _error;
  String? _result; 

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get result => _result;

  
  Future<void> analyzeSymptoms(String symptom) async {
    _isLoading = true;
    _error = null;
    _result = null; 
    notifyListeners();

    try {
      
      _result = await _service.symptomAnalysis(symptom);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _result = null;
    _error = null;
    _isLoading = false; 
    notifyListeners();
  }
}