import 'package:flutter/material.dart';
import 'package:memory_app/Jeu/resultat_screen.dart';
import 'package:memory_app/utils.dart';
import 'dart:io';
import 'dart:math';

class GameLogicScreen extends StatefulWidget {
  final List<String> initialPairs;
  final List<String> allImages;

  GameLogicScreen({required this.initialPairs, required this.allImages});

  @override
  _GameLogicScreenState createState() => _GameLogicScreenState();
}

class _GameLogicScreenState extends State<GameLogicScreen> {
  int currentLevel = 1;
  List<String> distractors = [];
  List<String> currentImages = []; // Liste des chemins réels des images
  List<bool> isImageMasked = []; // État d'affichage des images
  String? firstSelectedImage;
  Map<String, String> selectedPair = {};
  Color scaffoldColor = ColorPalette.surface;
  Set<int> markedTiles = {}; // Indices des tuiles sélectionnées
  bool isInteractionDisabled = false;

  Stopwatch stopwatch = Stopwatch();

  List<String> gameTimestamps = [];

  int score = 0; // Score cumulé
  int nbrCorrect = 0;
  int maxScorePerLevel = 50; // Score maximal par niveau
  int penaltyPerSecond = 10; // Pénalité par seconde
  double averageCorrectReaction = 0;
  double averageNonCorrectReaction = 0;


  @override
  void initState() {
    super.initState();
    _startLevel();
  }

  void _startLevel() {
    final random = Random();

    // Sélectionner une paire aléatoire
    final pairIndex = random.nextInt(widget.initialPairs.length ~/ 2);
    selectedPair = {
      'neutral': widget.initialPairs[pairIndex * 2],
      'user': widget.initialPairs[pairIndex * 2 + 1],
    };

    // Filtrer les distracteurs
    distractors = widget.allImages
        .where((image) => !widget.initialPairs.contains(image))
        .toSet()
        .toList();


    // Choisir les distracteurs
    final numDistractors = (currentLevel <= 30) ? 2 : 6;
    final selectedDistractors = (distractors..shuffle(random)).take(numDistractors).toList();

    // Initialiser les images pour le niveau
    currentImages = [
      selectedPair['neutral']!,
      selectedPair['user']!,
      ...selectedDistractors,
    ]..shuffle(random);

    isImageMasked = List.filled(currentImages.length, false);

    scaffoldColor = ColorPalette.surface;
    markedTiles.clear();
    stopwatch.reset();
    stopwatch.start();
    isInteractionDisabled = false;
  }

  void _onImageSelected(int index) {
    if (isInteractionDisabled) return;
    setState(() {

      if (firstSelectedImage == null) {
        isInteractionDisabled = true;
        // Première sélection
        firstSelectedImage = currentImages[index];
        markedTiles.add(index);

        if (currentLevel>15 && currentLevel<=30 || currentLevel >45) {
          // Masquer toutes les autres images
          for (int i = 0; i < isImageMasked.length; i++) {
            if (i != index) {
              isImageMasked[i] = true;
            }
          }
        }
        isInteractionDisabled = false;
      }
      else if (currentImages[index] != firstSelectedImage) {
        isInteractionDisabled = true;
        // Deuxième sélection : valider la paire
        String secondSelectedImage = currentImages[index];
        bool isCorrect = (firstSelectedImage == selectedPair['neutral'] &&
            secondSelectedImage == selectedPair['user']) ||
            (firstSelectedImage == selectedPair['user'] &&
                secondSelectedImage == selectedPair['neutral']);

        // Mise à jour de la couleur de validation
        scaffoldColor = isCorrect ? Colors.green : Colors.red;

        stopwatch.stop();
        double timeTaken = stopwatch.elapsedMilliseconds / 1000;

        if (isCorrect) {
          nbrCorrect++;
          score += 3+max(maxScorePerLevel - (timeTaken * penaltyPerSecond).round(), 0);
          averageCorrectReaction+=timeTaken;
        } else {
          averageNonCorrectReaction+=timeTaken;
        }


        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            currentLevel++;
            if (currentLevel <= 60) {
              _startLevel();
            } else {
              _endGame();
            }
            firstSelectedImage = null;
            isInteractionDisabled = false;
          });
        });
      }
    });
  }

  Future<void> _endGame() async {
    String timestamp = DateTime.now().toIso8601String();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScoreScreen(
          score: score,
          correctAnswers: nbrCorrect,
          totalAnswers: 60,
          averageResponseTime: (averageCorrectReaction+averageNonCorrectReaction)/60,
          averageCorrectResponseTime: averageCorrectReaction/nbrCorrect,
          timestamp: timestamp
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        title: Text("JEU - Score: ${score.toStringAsFixed(1)}"),
        backgroundColor: ColorPalette.primary,
        foregroundColor: ColorPalette.onPrimary,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(currentImages.length, (index) {
              final isMasked = isImageMasked[index];
              return GestureDetector(
                onTap: () => _onImageSelected(index),
                child: SizedBox(
                  width: Dimension.height * 0.18,
                  height: Dimension.height * 0.18,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: markedTiles.contains(index)
                              ? Colors.blue
                              : Colors.grey.shade400,
                          width: 3),
                      borderRadius: BorderRadius.circular(8),
                      color: isMasked ? Colors.black : Colors.grey.shade200,
                      image: !isMasked
                          ? DecorationImage(
                        image: currentImages[index].startsWith('assets')
                            ? AssetImage(currentImages[index]) as ImageProvider
                            : FileImage(File(currentImages[index])),
                        fit: BoxFit.cover,
                      )
                          : null,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
