import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'game_detail_page.dart';
import 'package:games/user_data.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({super.key});

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  List games = [];
  List genres = [];

  int currentPage = 1;
  bool isLoading = true;
  bool isFetchingMore = false;

  final String apiKey = "53b358c679984af9b14675940a5bfdcc";

  ScrollController controller = ScrollController();

  String search = "";
  String? selectedGenre;

  @override
  void initState() {
    super.initState();
    fetchGenres();
    fetchGames();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        fetchMoreGames();
      }
    });
  }

  String fixImage(String? url) {
    if (url == null || url.isEmpty) {
      return "https://picsum.photos/300";
    }
    return url.replaceFirst("http://", "https://");
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "?";

    try {
      final d = DateTime.parse(date);
      return "${d.day.toString().padLeft(2, '0')}/"
          "${d.month.toString().padLeft(2, '0')}/"
          "${d.year}";
    } catch (e) {
      return date;
    }
  }

  Future<void> fetchGenres() async {
    final url = "https://api.rawg.io/api/genres?key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    setState(() {
      genres = data['results'];
    });
  }

  String buildUrl() {
    String url =
        "https://api.rawg.io/api/games?key=$apiKey&page=$currentPage&page_size=20";

    if (search.isNotEmpty) {
      url += "&search=$search";
    }

    if (selectedGenre != null && selectedGenre!.isNotEmpty) {
      url += "&genres=$selectedGenre";
    }

    return url;
  }

  Future<void> fetchGames() async {
    setState(() => isLoading = true);

    final response = await http.get(Uri.parse(buildUrl()));
    final data = json.decode(response.body);

    setState(() {
      games = data['results'] ?? [];
      isLoading = false;
    });
  }

  Future<void> fetchMoreGames() async {
    if (isFetchingMore) return;

    setState(() => isFetchingMore = true);

    currentPage++;

    final response = await http.get(Uri.parse(buildUrl()));
    final data = json.decode(response.body);

    setState(() {
      games.addAll(data['results'] ?? []);
      isFetchingMore = false;
    });
  }

  void refresh() {
    currentPage = 1;
    games.clear();
    fetchGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Buscar jogo...",
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    prefixIcon: const Icon(Icons.search, color: Colors.amber),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (value) {
                    search = value.trim();
                    refresh();
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedGenre,
                  dropdownColor: const Color(0xFF1A1A1A),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1A1A1A),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text("Filtrar por gênero",
                      style: TextStyle(color: Colors.grey)),
                  items: [
                    const DropdownMenuItem(
                      value: "",
                      child: Text("Todos"),
                    ),
                    ...genres.map<DropdownMenuItem<String>>((g) {
                      return DropdownMenuItem(
                        value: g['slug'],
                        child: Text(g['name']),
                      );
                    }).toList()
                  ],
                  onChanged: (value) {
                    selectedGenre = value == "" ? null : value;
                    refresh();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  )
                : GridView.builder(
                    controller: controller,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final game = games[index];

                      return GestureDetector(
                        onTap: () {
                          // 🔥 SALVA O JOGO CLICADO
                          UserData.lastGame = game;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  GameDetailPage(gameId: game['id']),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                child: Image.network(
                                  fixImage(game['background_image']),
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.network(
                                      "https://picsum.photos/300"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      game['name'] ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "⭐ ${game['rating'] ?? "N/A"}",
                                      style: const TextStyle(
                                          color: Colors.amber, fontSize: 12),
                                    ),
                                    Text(
                                      "📅 ${formatDate(game['released'])}",
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (isFetchingMore)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(color: Colors.amber),
            ),
        ],
      ),
    );
  }
}
