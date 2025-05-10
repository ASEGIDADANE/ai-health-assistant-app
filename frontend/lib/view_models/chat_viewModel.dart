import 'package:flutter/material.dart';

class ChatViewModel extends ChangeNotifier {
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: 'AI',
      message: "Hello! I'm your AI Health Assistant. I can help you with general health questions, symptom information, and wellness advice. How can I assist you today?",
      time: '10:00 AM',
      isAI: true,
    ),
  ];

  List<_ChatMessage> get messages => _messages;

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    _messages.add(_ChatMessage(sender: 'You', message: text, time: 'Now', isAI: false));
    notifyListeners();

    // Simulate API response (replace with actual API call)
    Future.delayed(const Duration(milliseconds: 800), () {
      _messages.add(_ChatMessage(
        sender: 'AI',
        message: "Regular exercise offers a wide array of benefits impacting nearly every system in the body. These benefits can be broadly categorized as:\n\n**Physical Benefits:\n\n* **Improved Cardiovascular Health: Reduces risk of heart disease, stroke, and high blood pressure. Strengthens the heart muscle, improves circulation, and lowers resting heart rate.\n* Weight Management: Burns calories, helps build muscle mass (which boosts metabolism), and contributes to weight loss or maintenance.\n* **Stronger Bones and Muscles",
        time: 'Now',
        isAI: true,
      ));
      notifyListeners();
    });
  }
}

class _ChatMessage {
  final String sender;
  final String message;
  final String time;
  final bool isAI;
  _ChatMessage({required this.sender, required this.message, required this.time, required this.isAI});
}
