import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  File? _image;
  String? _recipe;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendImageToChatGPT() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
      _recipe = null;
    });

    try {
      // Convert image to base64
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Prepare the request payload
      final requestPayload = jsonEncode({
        'model': 'gpt-4o',
        'messages': [
          {
            'role': 'user',
            'content':
            'describe what food is in the photo and remove the word assumed then create a recipe from the ingredients you just described dont add any ingredients and try and avoid pork and wine and finally write everything with the same font. The image is encoded as: data:image/jpeg;base64,$base64Image'
          }
        ],
        'max_tokens': 2000,
      });

      final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
      final response = await http.post(
        uri,
        headers: {
          'Authorization': 'Your Api key',
          'Content-Type': 'application/json',
        },
        body: requestPayload,
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _recipe = result['choices'][0]['message']['content'];
        });
      } else {
        setState(() {
          _recipe = 'Failed to generate recipe. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _recipe = 'Failed to generate recipe. Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToFavorites() async {
    if (_recipe == null || _recipe!.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(_recipe!);
    await prefs.setStringList('favorites', favorites);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Recipe added to favorites!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload from Gallery"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text("No image selected.")
                  : Image.file(_image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text("Pick Image from Gallery"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _image == null || _isLoading ? null : _sendImageToChatGPT,
                child: _isLoading ? CircularProgressIndicator() : Text("Send Image"),
              ),
              SizedBox(height: 20),
              _recipe == null
                  ? Text("No recipe generated yet.")
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Generated Recipe:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(_recipe!, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addToFavorites,
                      child: Text("Add to Favorites"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
