import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favorites = [];
  List<String> _selectedFavorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _deleteSelected() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = _favorites.where((item) => !_selectedFavorites.contains(item)).toList();
      _selectedFavorites.clear();
      prefs.setStringList('favorites', _favorites);
    });
  }

  void _toggleSelection(String item) {
    setState(() {
      if (_selectedFavorites.contains(item)) {
        _selectedFavorites.remove(item);
      } else {
        _selectedFavorites.add(item);
      }
    });
  }

  bool _isSelected(String item) => _selectedFavorites.contains(item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        actions: [
          if (_selectedFavorites.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteSelected,
            ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final item = _favorites[index];
          final isSelected = _isSelected(item);
          return Card(
            color: isSelected ? Colors.blue.withOpacity(0.5) : null,
            child: ListTile(
              title: Text(
                item,
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(
                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                color: isSelected ? Colors.blue : null,
              ),
              onTap: () => _toggleSelection(item),
            ),
          );
        },
      ),
    );
  }
}
