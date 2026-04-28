import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'game_detail_page.dart';
import 'package:games/user_data.dart';

class ReleasesPage extends StatefulWidget {
  const ReleasesPage({super.key});

  @override
  State<ReleasesPage> createState() => _ReleasesPageState();
}

class _ReleasesPageState extends State<ReleasesPage> {
  List games = [];
  bool isLoading = true;

  String search = "";
  String filter = "3m";

  final String apiKey = "53b358c679984af9b14675940a5bfdcc";

  @override
  void initState() {
    super.initState();
    fetchGames();
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

  String getDateRange() {
    final now = DateTime.now();
    DateTime past;

    if (filter == "7d") {
      past = now.subtract(const Duration(days: 7));
    } else if (filter == "1m") {
      past = DateTime(now.year, now.month - 1, now.day);
    } else {
      past = DateTime(now.year, now.month - 3, now.day);
    }

    String format(DateTime d) =>
        "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

    return "${format(past)},${format(now)}";
  }

  Future<void> fetchGames() async {
    setState(() => isLoading = true);

    final dates = getDateRange();

    String url =
        "https://api.rawg.io/api/games?key=$apiKey&dates=$dates&ordering=-released&page_size=20";

    if (search.isNotEmpty) {
      url += "&search=$search";
    }

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      setState(() {
        games = data['results'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  String fixImage(String? url) {
    if (url == null || url.isEmpty) {
      return "https://picsum.photos/300";
    }
    return url.replaceFirst("http://", "https://");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Buscar lançamento...",
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
                      fetchGames();
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: filter,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "7d",
                        child: Text("Última semana"),
                      ),
                      DropdownMenuItem(
                        value: "1m",
                        child: Text("Último mês"),
                      ),
                      DropdownMenuItem(
                        value: "3m",
                        child: Text("Últimos 3 meses"),
                      ),
                    ],
                    onChanged: (value) {
                      filter = value!;
                      fetchGames();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.amber))
                  : ListView.builder(
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
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    fixImage(game['background_image']),
                                    width: 100,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        "https://picsum.photos/300",
                                        width: 100,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        game['name'] ?? "",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "📅 ${formatDate(game['released'])}",
                                        style:
                                            const TextStyle(color: Colors.grey),
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
          ],
        ),
      ),
    );
  }
}
