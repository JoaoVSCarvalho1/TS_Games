import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';
import 'game_detail_page.dart';
import 'package:games/user_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  String fixImage(String? url) {
    if (url == null || url.isEmpty) {
      return "https://picsum.photos/300";
    }
    return url.replaceFirst("http://", "https://");
  }

  @override
  Widget build(BuildContext context) {
    final lastGame = UserData.lastGame;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => goToHome(context),
        ),
        title: const Text("Perfil", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 PERFIL
            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.person, color: Colors.black, size: 35),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserData.name ?? "Jogador",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      UserData.email ?? "Sem email",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "🎮 Último jogo visto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            lastGame == null
                ? const Text(
                    "Nenhum jogo visualizado ainda",
                    style: TextStyle(color: Colors.grey),
                  )
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              GameDetailPage(gameId: lastGame["id"]),
                        ),
                      );
                    },
                    child: Container(
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
                              fixImage(lastGame["image"]),
                              width: 100,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              lastGame["name"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
