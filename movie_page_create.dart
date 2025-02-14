//import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateMoviePage extends StatefulWidget {
  const CreateMoviePage({super.key});

  @override
  _CreateMoviePageState createState() => _CreateMoviePageState();
}

class _CreateMoviePageState extends State<CreateMoviePage> {
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();

  // POST request ke JSONPlaceholder
  Future<void> createMovie(String title, String year) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.post(
      url,
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'title': title,
        'year': year,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('Success! New post created: $responseData');

      // Tampilkan dialog sukses
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Movie Created (Dummy)'),
          content: Text('Response: $responseData'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                Navigator.pop(context); // kembali ke MovieListPage
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
     print('Failed to create movie. Status code: ${response.statusCode}');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to create movie.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Movie (Dummy)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Movie Title'),
            ),
            TextField(
              controller: _yearController,
              decoration: const InputDecoration(labelText: 'Year'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final year = _yearController.text;
                createMovie(title, year);
              },
              child: const Text('Submit Movie'),
            ),
          ],
        ),
     ),
);
}
}