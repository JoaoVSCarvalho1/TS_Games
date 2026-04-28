import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDetailPage extends StatefulWidget {
  final int gameId;

  const GameDetailPage({super.key, required this.gameId});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  Map<String, dynamic>? game;
  bool isLoading = true;

  String fixImage(String? url) {
    if (url == null || url.isEmpty) {
      return "https://picsum.photos/400";
    }
    return url.replaceFirst("http://", "https://");
  }

  @override
  void initState() {
    super.initState();
    fetchGameDetails();
  }

  Future<void> fetchGameDetails() async {
    try {
      final url =
          "https://api.rawg.io/api/games/${widget.gameId}?key=53b358c679984af9b14675940a5bfdcc";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          game = data;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // 📅 FORMATA DATA
  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "Não informado";

    try {
      final parts = date.split("-");
      return "${parts[2]}/${parts[1]}/${parts[0]}";
    } catch (e) {
      return date;
    }
  }

  Widget buildInfoCard(String title, String value) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          value.isNotEmpty ? value : "Não informado",
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  // 🔥 LISTAS DA API
  String getListNames(List? list, String key) {
    if (list == null || list.isEmpty) return "Não informado";

    return list.map((e) => e[key]["name"]).join(", ");
  }

  String getSimpleList(List? list, String key) {
    if (list == null || list.isEmpty) return "Não informado";

    return list.map((e) => e[key]).join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : game == null
              ? const Center(
                  child: Text("Erro ao carregar jogo",
                      style: TextStyle(color: Colors.white)),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🎮 IMAGEM
                      Image.network(
                        fixImage(game!["background_image"]),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.network(
                          "https://picsum.photos/400",
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 🎮 NOME
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          game!["name"] ?? "",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            buildInfoCard(
                                "⭐ Nota", "${game!["rating"] ?? "N/A"}"),
                            buildInfoCard(
                                "📅 Lançamento", formatDate(game!["released"])),
                            buildInfoCard("⏱️ Tempo de jogo",
                                "${game!["playtime"] ?? "?"} horas"),
                            buildInfoCard("🎯 Metacritic",
                                "${game!["metacritic"] ?? "N/A"}"),
                            buildInfoCard(
                                "🎮 Gêneros",
                                (game!["genres"] as List? ?? [])
                                    .map((g) => g["name"])
                                    .join(", ")),
                            buildInfoCard(
                                "💻 Plataformas",
                                (game!["platforms"] as List? ?? [])
                                    .map((p) => p["platform"]["name"])
                                    .join(", ")),
                            buildInfoCard(
                                "🏢 Desenvolvedoras",
                                (game!["developers"] as List? ?? [])
                                    .map((d) => d["name"])
                                    .join(", ")),
                            buildInfoCard(
                                "📦 Publishers",
                                (game!["publishers"] as List? ?? [])
                                    .map((p) => p["name"])
                                    .join(", ")),
                            const SizedBox(height: 30),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
