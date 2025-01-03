import 'package:flutter/material.dart';
import 'package:memory_app/game_menu_screen.dart';
import 'package:memory_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late SharedPreferences prefs;

  // Variables pour stocker les statistiques
  late int bestScore;
  late double bestAvgCorrTime;
  late int nbrParties;
  late double avgScore;
  late double avgCorrAnswers;
  late double avgCorrTime;
  late double avgTime;
  late int totalCorrectAnswers;
  late int totalPoints;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    prefs = await SharedPreferences.getInstance();

    // Charger les statistiques
    setState(() {
      bestScore = prefs.getInt('bestScore') ?? 0;
      bestAvgCorrTime = prefs.getDouble('bestAvgCorrTime') ?? double.infinity;
      nbrParties = prefs.getInt('nbrParties') ?? 0;
      avgScore = prefs.getDouble('avgScore') ?? 0;
      avgCorrAnswers = prefs.getDouble('avgCorr') ?? 0;
      avgCorrTime = prefs.getDouble('avgCorrTime') ?? double.infinity;
      avgTime = prefs.getDouble('avgTime') ?? double.infinity;
      totalCorrectAnswers = (avgCorrAnswers * nbrParties).toInt();
      totalPoints = (avgScore * nbrParties).toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.surface, // Couleur de fond similaire à l'image
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 80,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            Text(
              'MEILLEUR SCORE : $bestScore points',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Meilleur temps moyen pour donner une réponse correcte dans une partie : ${bestAvgCorrTime == double.infinity ? 'N/A' : '${bestAvgCorrTime.toStringAsFixed(2)}s'}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              '$nbrParties parties jouées',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Nombre moyen de bonnes réponses par partie : ${avgCorrAnswers.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Score Moyen : ${avgScore.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Temps moyen pour donner une bonne réponse : ${avgCorrTime == double.infinity ? 'N/A' : '${avgCorrTime.toStringAsFixed(2)}s'}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Temps moyen pour donner une réponse : ${avgTime == double.infinity ? 'N/A' : '${avgTime.toStringAsFixed(2)}s'}',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              'Total bonnes réponses : $totalCorrectAnswers',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              'Total de points : $totalPoints',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GameMenuScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text(
                'Retour',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPalette.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
