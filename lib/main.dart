import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'gemini_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextToImagePage(),
    );
  }
}

class TextToImagePage extends StatefulWidget {
  @override
  _TextToImagePageState createState() => _TextToImagePageState();
}

class _TextToImagePageState extends State<TextToImagePage> {
  final _promptController = TextEditingController();
  Uint8List? _imageBytes;
  bool _isLoading = false;
  
  final geminiService = GeminiService('YOUR_GEMINI_API_KEY');

  Future<void> _generateImage() async {
    setState(() => _isLoading = true);
    final base64Image = await geminiService.generateImageFromPrompt(_promptController.text);
    if (base64Image != null) {
      setState(() => _imageBytes = base64Decode(base64Image));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini Text-to-Image")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _promptController,
              decoration: InputDecoration(
                labelText: "Nhập văn bản mô tả",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _generateImage,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text("Tạo hình ảnh"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _imageBytes != null
                  ? Image.memory(_imageBytes!)
                  : Center(child: Text("Chưa có ảnh")),
            ),
          ],
        ),
      ),
    );
  }
}



