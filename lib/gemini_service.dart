import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;
  GeminiService(this.apiKey);

  Future<String?> generateImageFromPrompt(String prompt) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey',
    );

    final body = {
      "contents": [
        {
          "parts": [
            {"text": prompt}
          ]
        }
      ]
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final imageBase64 = data['candidates'][0]['content']['parts'][0]['inlineData']['data'];
      return imageBase64;
    } else {
      print('Error: ${response.body}');
      return null;
    }
  }
}
