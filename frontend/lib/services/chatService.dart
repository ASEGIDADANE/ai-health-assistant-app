import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart'; 

class ChatService {
 

 
  static const String _chatEndpoint = "/api/your-chat-endpoint"; // MODIFY THIS

  final String _fullChatApiUrl = "YOUR_BACKEND_BASE_URL_HERE" + _chatEndpoint;


  Future<chatModel> getAiResponse(String userMessage) async {

    if (_fullChatApiUrl.startsWith("YOUR_BACKEND_BASE_URL_HERE")) {
      print("ChatService: Backend URL not configured. Using simulated response.");
      await Future.delayed(const Duration(milliseconds: 900)); 
      if (userMessage.toLowerCase().contains("hello")) {
        return chatModel(response: "Hello there! This is a simulated response as backend is not fully connected.");
      }
      return chatModel(response: "Simulated AI response for: '$userMessage'");
    }
    

    try {
      final response = await http.post(
        Uri.parse(_fullChatApiUrl),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'message': userMessage}), 
      ).timeout(const Duration(seconds: 30)); 

      if (response.statusCode == 200) {
        
        return chatModel.fromJson(jsonDecode(response.body));
      } else {
        
        String errorMessage = 'Failed to get AI response. Server error: ${response.statusCode}.';
        try {
           
            final errorBody = jsonDecode(response.body);
            if (errorBody['error'] != null) {
                errorMessage = 'Error: ${errorBody['error']}';
            } else if (errorBody['message'] != null) {
                errorMessage = 'Error: ${errorBody['message']}';
            }
        } catch (_) {
        
            print('Could not parse error body: ${response.body}');
        }
        print('ChatService Error: $errorMessage, Response Body: ${response.body}');
        throw Exception(errorMessage);
      }
    } catch (e) {
      
      print('ChatService Exception: $e');
      throw Exception('Failed to communicate with AI service: ${e.toString()}');
    }
  }
}