
import 'dart:convert';

class chatModel {
    String response;

    chatModel({
        required this.response,
    });

    factory chatModel.fromJson(Map<String, dynamic> json) => chatModel(
        response: json["response"],
    );

    Map<String, dynamic> toJson() => {
        "response": response,
    };
}





