import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'game_detail_page.dart';
import 'games_page.dart';
import 'releases_page.dart';

import 'profile_page.dart';
import 'about_page.dart';
import 'login_page.dart';

import 'package:games/user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List games = [];
  bool isLoading = true;

  int selectedIndex = 0;

  int currentPage = 1;
  bool isFetchingMore = false;
  ScrollController scrollController = ScrollController();

  final String apiKey = "53b358c679984af9b14675940a5bfdcc";

  @override
  void initState() {
    super.initState();
    fetchGames();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        fetchMoreGames();
      }
    });
  }

  Future<void> fetchGames() async {
    final url =
        "https://api.rawg.io/api/games?key=$apiKey&page_size=20&page=$currentPage";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          games = data['results'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchMoreGames() async {
    if (isFetchingMore) return;

    setState(() => isFetchingMore = true);

    currentPage++;

    final url =
        "https://api.rawg.io/api/games?key=$apiKey&page=$currentPage&page_size=20";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          games.addAll(data['results']);
        });
      }
    } catch (e) {}

    setState(() => isFetchingMore = false);
  }

  // 🔥 MENU DO PERFIL
  void openProfileMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Colors.amber,
                child: Icon(Icons.person, size: 40, color: Colors.black),
              ),
              const SizedBox(height: 10),
              const Text(
                "Jogador",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title:
                    const Text("Perfil", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfilePage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title:
                    const Text("Sobre", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AboutPage(),
                    ),
                  );
                },
              ),
              const Divider(color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Sair", style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ✅ SALVAR JOGO + ABRIR DETALHE
  void openGame(dynamic game) {
    UserData.lastGame = {
      "id": game['id'],
      "name": game['name'],
      "image": game['background_image'],
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameDetailPage(gameId: game['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "TOP",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: "JOGOS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: "LANÇAMENTOS",
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : selectedIndex == 0
              ? _buildHomeContent()
              : selectedIndex == 1
                  ? const GamesPage()
                  : const ReleasesPage(),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Olá, ${UserData.name ?? 'jogador'} 👋",
                      style: TextStyle(color: Colors.grey)),
                  Text(
                    "TS Games",
                    style: GoogleFonts.poppins(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // 👤 BOTÃO PERFIL
              GestureDetector(
                onTap: openProfileMenu,
                child: const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.person, color: Colors.black),
                ),
              )
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            "🔥 Destaque",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              openGame(games[0]); // 🔥 AGORA SALVA AO CLICAR
            },
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(
                    games[0]['background_image'] ??
                        "https://via.placeholder.com/400",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            "🎮 Jogos populares",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];

              return GestureDetector(
                onTap: () {
                  openGame(game); // 🔥 SALVA AQUI TAMBÉM
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          game['background_image'] ??
                              "https://via.placeholder.com/150",
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game['name'] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "⭐ ${game['rating']}",
                              style: const TextStyle(color: Colors.amber),
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

          if (isFetchingMore)
            const Padding(
              padding: EdgeInsets.all(15),
              child: Center(
                child: CircularProgressIndicator(color: Colors.amber),
              ),
            ),
        ],
      ),
    );
  }
}
