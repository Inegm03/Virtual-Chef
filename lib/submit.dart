import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_page.dart';

class RecipePage extends StatefulWidget {
  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  final TextEditingController _recipeController = TextEditingController();
  String _responseText = '';
  bool _isLoading = false;

  Future<void> _submitRecipe() async {
    final String recipeText = _recipeController.text;
    if (recipeText.isEmpty) {
      setState(() {
        _responseText = 'Please enter some ingredients.';
      });
      return;
    }

    final String prompt =
        "Make a recipe using these ingredients, don't add any other ingredients to it and if it's less than three ingredients say that you need one more ingredient. Write it all with the same size to avoid # ,* font and size. Finally, don't include pork or wine: \n$recipeText";

    setState(() {
      _isLoading = true;
      _responseText = '';
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Your Api Key', // Replace with your actual API key
        },
        body: jsonEncode({
          'model': 'gpt-4-turbo', // Adjust the model as per your subscription
          'messages': [
            {
              'role': 'user',
              'content': prompt
            }
          ],
          'max_tokens': 2000,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final generatedRecipe = responseData['choices'][0]['message']['content'].trim();
        setState(() {
          _responseText = generatedRecipe.isNotEmpty
              ? generatedRecipe
              : 'No recipe generated. Try again with different ingredients.';
        });
      } else {
        setState(() {
          _responseText = 'Failed to generate recipe. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Failed to generate recipe. Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addToFavorites() async {
    if (_responseText.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.add(_responseText);
    await prefs.setStringList('favorites', favorites);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Recipe added to favorites!'),
    ));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        title: Text("Write the ingredients"),
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/submitt.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: _recipeController,
                    maxLines: 10, // Increase this number for more lines in the text field
                    decoration: InputDecoration(
                      hintText: "Enter your ingredients here",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.8), // Adjust this to make the text field more readable
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black, // Background color
                      foregroundColor: Colors.white, // Text color
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding as needed
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Loader color
                    )
                        : Text('Submit Recipe'),
                  ),

                  SizedBox(height: 20),
                  if (_responseText.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Generated Recipe:",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text(_responseText,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(

                          onPressed: _addToFavorites,
                          child: Text("Add to Favorites",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _recipeController.dispose();
    super.dispose();
  }
}
