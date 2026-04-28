import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  // 🔥 VOLTAR PARA HOME (FORÇADO)
  void goToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D0D),
        elevation: 0,

        // 🔥 BOTÃO VOLTAR PERSONALIZADO
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => goToHome(context),
        ),

        title: const Text(
          "Sobre",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "TS Games 🎮",
              style: GoogleFonts.poppins(
                color: Colors.amber,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Seu hub completo de jogos",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 25),
            const Text(
              "O que é o TS Games?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "O TS Games é um aplicativo desenvolvido para ajudar jogadores a descobrir, explorar e acompanhar jogos de forma simples e rápida. "
              "Aqui você encontra informações detalhadas sobre diversos jogos, incluindo notas, datas de lançamento, gêneros e muito mais.",
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 25),
            const Text(
              "O que você pode fazer?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _item("🔥 Ver jogos em destaque"),
            _item("🎮 Explorar jogos populares"),
            _item("🆕 Acompanhar lançamentos recentes"),
            _item("🔍 Buscar jogos específicos"),
            _item("📊 Ver informações detalhadas de cada jogo"),
            const SizedBox(height: 25),
            const Text(
              "Objetivo do app",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "O objetivo do TS games é centralizar informações sobre jogos em um só lugar, "
              "facilitando a vida de quem quer descobrir novos jogos ou acompanhar lançamentos.",
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 25),
            const Text(
              "Tecnologias utilizadas",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "• Flutter\n"
              "• API RAWG\n"
              "• HTTP\n"
              "• Tradução automática",
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 25),
            const Text(
              "Desenvolvedor",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Desenvolvido como projeto de estudo e prática com Flutter.",
              style: TextStyle(color: Colors.white70, height: 1.5),
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Versão 1.0",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}
