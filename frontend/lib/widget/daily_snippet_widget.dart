import 'package:flutter/material.dart';
import '../services/api_service.dart'; 
import '../models/health_snippet_model.dart'; 

class DailyHealthSnippet extends StatefulWidget {
  const DailyHealthSnippet({super.key});

  @override
  State<DailyHealthSnippet> createState() => _DailyHealthSnippetState();
}

class _DailyHealthSnippetState extends State<DailyHealthSnippet> {
  final ApiService _apiService = ApiService();
  HealthSnippet? _snippet;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSnippet();
  }

  Future<void> _loadSnippet() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final snippet = await _apiService.fetchDailySnippet();
      if (mounted) { 
        setState(() {
          _snippet = snippet;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Could not fetch snippet. Please try again later.";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 10),
            Text("Loading health tip..."),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _errorMessage,
          style: TextStyle(color: Colors.red.shade700),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (_snippet == null) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "No health tip available today.",
          textAlign: TextAlign.center,
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "💡 Did You Know?", 
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _snippet!.text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}