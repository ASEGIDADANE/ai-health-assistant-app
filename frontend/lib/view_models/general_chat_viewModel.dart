import 'package:flutter/material.dart';
import 'package:frontend/services/generalChatServices.dart';


class GeneralChatViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String? _error;
  
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: 'AI',
      message: "Hello! I'm your AI Health Assistant. I can help you with general health questions, symptom information, and wellness advice. How can I assist you today?",
      time: '10:00 AM',
      isAI: true,
    ),
  ];

  List<_ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    _error = null;
    _isLoading = true;
    notifyListeners();
    
    // Add user message
    _messages.add(_ChatMessage(sender: 'You', message: text, time: 'Now', isAI: false));
    notifyListeners();

    try {
      // Get response from API
      final response = await _apiService.sendMessage(text);
      
      // Add AI response
      _messages.add(_ChatMessage(
        sender: 'AI',
        message: response,
        time: 'Now',
        isAI: true,
      ));
    } catch (e) {
      _error = e.toString();
      // Add error message
      _messages.add(_ChatMessage(
        sender: 'AI',
        message: e.toString().replaceAll('Exception: ', ''),
        time: 'Now',
        isAI: true,
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class _ChatMessage {
  final String sender;
  final String message;
  final String time;
  final bool isAI;
  _ChatMessage({required this.sender, required this.message, required this.time, required this.isAI});
}
