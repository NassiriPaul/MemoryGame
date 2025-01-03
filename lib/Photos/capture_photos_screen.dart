import 'package:flutter/material.dart';
import 'package:memory_app/Photos/steps_pictures.dart';
import 'package:memory_app/privacy_screen.dart';
import 'package:memory_app/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CapturePhotosScreen(),
    );
  }
}

class CapturePhotosScreen extends StatelessWidget {


  const CapturePhotosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: ColorPalette.surface, // Couleur de fond
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, height*0.05,0, 0),
                child: Text(
                  PresetText.consigneCapturePhotos,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorPalette.onSurface,
                    fontSize: 18,
                  ),
                ),
              ),
              Column(
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigation vers une autre page (sera détaillée plus tard)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StepsScreen(
                            modelImages: [
                              "assets/modeles/tete.jpg",
                              "assets/modeles/face.jpg",
                              "assets/modeles/profil.jpeg",
                              "assets/modeles/buste.jpg",
                              "assets/modeles/jambes.jpg",
                            ]
                          )
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: ColorPalette.primary,
                      foregroundColor: ColorPalette.onPrimary,// Couleur du bouton
                      textStyle: const TextStyle(fontSize: 18),
                      minimumSize: Size(width*0.8, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Prendre photos"),
                  ),
                  SizedBox(height: 0.01*height),
                  const Text(
                    "Vous n'avez pas encore validé les 5 photos.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigation vers la page de confidentialité
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyScreen()),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: ColorPalette.secondary,
                  foregroundColor: ColorPalette.onSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), minimumSize: Size(0.33*width, 0)
                ),
                child: const Text("Confidentialité"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
