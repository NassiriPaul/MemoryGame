import 'package:flutter/material.dart';
import 'package:memory_app/game_menu_screen.dart';
import 'package:memory_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreScreen extends StatefulWidget {
  final int score;
  final int correctAnswers;
  final int totalAnswers;
  final double averageResponseTime;
  final double averageCorrectResponseTime;
  final String timestamp;

  const ScoreScreen({
    required this.score,
    required this.correctAnswers,
    required this.totalAnswers,
    required this.averageResponseTime,
    required this.averageCorrectResponseTime,
    required this.timestamp,
    super.key,
  });

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  SharedPreferences? prefs; // Remplacer `late` par nullable
  int bestScore = 0;
  int nbrParties = 0;
  double avgScore = 0;
  double avgCorr = 0;
  double avgCorrTime = 0;
  double avgTime = 0;
  double bestAvgCorrTime = double.infinity;

  @override
  void initState() {
    super.initState();
    _loadAndUpdatePreferences();
  }

  Future<void> _loadAndUpdatePreferences() async {
    prefs = await SharedPreferences.getInstance();

    // Charger les valeurs actuelles des préférences
    nbrParties = prefs?.getInt('nbrParties') ?? 0;
    bestScore = prefs?.getInt('bestScore') ?? 0;
    avgScore = prefs?.getDouble('avgScore') ?? 0;
    avgCorr = prefs?.getDouble('avgCorr') ?? 0;
    avgCorrTime = prefs?.getDouble('avgCorrTime') ?? double.infinity;
    avgTime = prefs?.getDouble('avgTime') ?? double.infinity;
    bestAvgCorrTime = prefs?.getDouble('bestAvgCorrTime') ?? double.infinity;

    // Mettre à jour les valeurs
    nbrParties++;
    avgScore = (avgScore * (nbrParties - 1) + widget.score) / nbrParties;
    avgCorr = (avgCorr * (nbrParties - 1) + widget.correctAnswers) / nbrParties;
    avgCorrTime = (avgCorrTime * (nbrParties - 1) + widget.averageCorrectResponseTime) / nbrParties;
    avgTime = (avgTime * (nbrParties - 1) + widget.averageResponseTime) / nbrParties;
    bestAvgCorrTime = bestAvgCorrTime > widget.averageCorrectResponseTime
        ? widget.averageCorrectResponseTime
        : bestAvgCorrTime;

    // Sauvegarder les préférences
    await prefs?.setInt('nbrParties', nbrParties);
    await prefs?.setInt('bestScore', bestScore > widget.score ? bestScore : widget.score);
    await prefs?.setDouble('avgScore', avgScore);
    await prefs?.setDouble('avgCorr', avgCorr);
    await prefs?.setDouble('avgCorrTime', avgCorrTime);
    await prefs?.setDouble('avgTime', avgTime);
    await prefs?.setDouble('bestAvgCorrTime', bestAvgCorrTime);

    // Rebuild l'interface avec les nouvelles données
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un indicateur de chargement si prefs n'est pas encore initialisé
    if (prefs == null) {
      return Scaffold(
        backgroundColor: ColorPalette.surface,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Calcul des réponses incorrectes
    final int incorrectAnswers = widget.totalAnswers - widget.correctAnswers;

    return Scaffold(
      backgroundColor: ColorPalette.surface,
      body: Center(
        child: Padding(
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
                '${widget.score} points',
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                bestScore > widget.score
                    ? 'Record personnel : $bestScore points'
                    : 'Nouveau record ! (ancien record : $bestScore points)',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '${widget.correctAnswers} bonnes réponses',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '$incorrectAnswers mauvaises réponses',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Temps de réponse moyen : ${widget.averageResponseTime.toStringAsFixed(2)} sec\n(toutes réponses confondues)',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Temps de bonne réponse moyen : ${widget.averageCorrectResponseTime.toStringAsFixed(2)} sec',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
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
                  'Retour au menu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: ColorPalette.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
