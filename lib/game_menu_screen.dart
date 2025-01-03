import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory_app/Photos/capture_photos_screen.dart';
import 'package:memory_app/Jeu/consigne_screen.dart';
import 'package:memory_app/privacy_screen.dart';
import 'package:memory_app/statistics_screen.dart';
import 'package:memory_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameMenuScreen extends StatefulWidget {
  const GameMenuScreen({super.key});

  @override
  _GameMenuScreenState createState() => _GameMenuScreenState();
}

class _GameMenuScreenState extends State<GameMenuScreen> with WidgetsBindingObserver {
  bool _photosChecked = false;
  bool _hasUserPhotos = false; // Supposé faux par défaut

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkUserPhotos();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkUserPhotos() async {
    final prefs = await SharedPreferences.getInstance();
    String appMode = prefs.getString('appMode') ?? 'controle';
    // Implémentez ici la logique pour vérifier si les photos user.jpg existent.
    // Par exemple, lire un répertoire et voir si N photos "xxx_user.jpg" existent.
    // Dans cet exemple, on simule qu'aucune photo n'est trouvée :
    _hasUserPhotos = await checkIfUserPhotosExist(5);

    setState(() {
      _photosChecked = true;
    });

    if (!_hasUserPhotos && appMode == "test") {
      // Redirection vers la page de capture photo
      // après le build actuel, pour éviter les erreurs de contexte
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CapturePhotosScreen()),
        );
      });
    }
  }

  Future<bool> checkIfUserPhotosExist(int numberOfPhotos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Vérifie l'existence de chaque photo enregistrée
    for (int i = 0; i < numberOfPhotos; i++) {
      final photoPath = prefs.getString('photo_$i');
      if (photoPath == null || !File(photoPath).existsSync()) {
        // Retourne false si une photo manque ou n'existe pas
        return false;
      }
    }

    // Retourne true si toutes les photos existent
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    if (!_photosChecked) {
      // Tant que la vérification n'est pas terminée, on peut afficher un loader
      return Scaffold(
        backgroundColor: ColorPalette.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Si on arrive ici, c’est que _photosChecked est true.
    // Si _hasUserPhotos est faux, on a déjà fait un pushReplacement vers la capture.
    // Si _hasUserPhotos est vrai, on affiche le menu normal.
    return Scaffold(
        backgroundColor: ColorPalette.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(0.05 * width),
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 0.66 * width,
                    child: const FittedBox(
                      fit: BoxFit.contain,
                      child: Row(
                        children: [
                          Text(
                            'lille ',
                            style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white),
                          ),
                          Text(
                            'TEC',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Boutons du menu
                  Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Naviguer vers l'écran consigne
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ConsigneScreen()),
                            );
                          },
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all<Size>(Size(width * 0.75, height * 0.02)),
                            backgroundColor: WidgetStateProperty.all<Color>(ColorPalette.primary),
                            foregroundColor: WidgetStateProperty.all<Color>(ColorPalette.onPrimary),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                )
                            )
                          ),
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Jouer',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.02),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                            );
                          },
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all<Size>(Size(width * 0.75, height * 0.02)),
                            backgroundColor: WidgetStateProperty.all<Color>(ColorPalette.primary),
                            foregroundColor: WidgetStateProperty.all<Color>(ColorPalette.onPrimary),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                )
                            )
                          ),
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Statistiques',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                            );
                          },
                          style: ButtonStyle(
                            fixedSize: WidgetStateProperty.all<Size>(Size(width * 0.75, height * 0.02)),
                            backgroundColor: WidgetStateProperty.all<Color>(ColorPalette.secondary),
                            foregroundColor: WidgetStateProperty.all<Color>(ColorPalette.onSecondary),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                )
                            )
                          ),
                          child: const FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              'Confidentialité',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}