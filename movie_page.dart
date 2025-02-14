import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie_page_create.dart';

// Model data
class Movie {
  final String title;
  final String year;
  final String poster;

  Movie({required this.title, required this.year, required this.poster});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? 'No Title',
      year: json['Year'] ?? 'No Year',
      poster: json['Poster'] ?? '',
    );
  }
}
class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late Future<List<Movie>> _moviesFuture;

  // Ganti dengan API Key OMDb Anda
  final String apiKey = '79832d67';

  @override
  void initState() {
    super.initState();
    // Ambil data saat widget pertama kali dibuat
    _moviesFuture = fetchMovies();
  }
  // Fungsi untuk mengambil data film dari OMDb
  Future<List<Movie>> fetchMovies() async {
    final url = Uri.parse('https://www.omdbapi.com/?apikey=$apiKey&s=The Walking Dead');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['Response'] == 'True') {
        // 'Search' berisi list film
        final List<dynamic> searchResults = data['Search'];
        return searchResults.map((json) => Movie.fromJson(json)).toList();
      } else {
        // Jika API merespon "False"
        throw Exception(data['Error'] ?? 'Failed to load movies');
      }
    } else {
      throw Exception('Failed to connect to OMDb API');
    }
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OMDb Movies (The Walking Dead)'),
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          // Loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Jika error
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Jika data berhasil diambil
          else if (snapshot.hasData) {
            final movies = snapshot.data!;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return _buildMovieCard(movie);
              },
            );
          } else {
            return const Center(child: Text('No data'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Buka halaman form untuk POST movie (dummy)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateMoviePage()),
          );
        },
      ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Poster
            // Jika Poster == 'N/A' atau URL kosong, kita bisa tampilkan placeholder
            movie.poster.isNotEmpty && movie.poster != 'N/A'
                ? Image.network(
                    movie.poster,
                    width: 80,
                    height: 120,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 80,
                    height: 120,
                    color: const Color.fromARGB(255, 38, 0, 255),
                    child: const Icon(Icons.image, color: Color.fromARGB(255, 255, 1, 1)),
                  ),
            const SizedBox(width: 16),
            // Info film
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('Year: ${movie.year}'),
                ],
              ),
            ),
          ],
        ),
    ),
);
}
}