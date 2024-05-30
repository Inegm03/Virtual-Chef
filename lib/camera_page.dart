import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_page.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  String? _recipe;

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File compressedFile = await _compressImage(File(pickedFile.path));
      setState(() {
        _image = compressedFile;
      });
    }
  }

  Future<File> _compressImage(File file) async {
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      file.absolute.path + '_compressed.jpg',
      quality: 40,
    );
    return compressedFile ?? file;
  }

  Future<void> _sendImageToChatGPT() async {
    if (_image == null) return;

    // Convert image to base64
    final bytes = await _image!.readAsBytes();
    final base64Image = base64Encode(bytes);

    // Prepare the request payload
    final requestPayload = jsonEncode({
      'model': 'gpt-4o',
      'messages': [
        {
          'role': 'user',
          'content': 'Create a recipe from the ingredients of this photo only. The image is encoded as: data:image/jpeg;base64,$base64Image'
        }
      ],
      'max_tokens': 300,
    });

    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'You Api key',
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
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  }

  Future<void> _addToFavorites() async {
    if (_recipe == null) return;
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
        title: Text("Camera Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesPage()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? Text("No image selected.")
                  : Image.file(_image!),
              ElevatedButton(
                onPressed: _takePicture,
                child: Text("Take Picture with Camera"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _image == null ? null : _sendImageToChatGPT,
                child: Text("Send Image"),
              ),
              SizedBox(height: 20),
              _recipe == null
                  ? Text("No recipe generated yet.")
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      _recipe!,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
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
