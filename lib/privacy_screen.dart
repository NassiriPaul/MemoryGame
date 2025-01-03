
import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Confidentialité"),
        backgroundColor: Colors.grey[300], // Couleur similaire à l'image
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white, // Fond blanc
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "Pour la réalisation de ce jeu, 3 photographies de vous, entièrement vêtue, si possible avec des vêtements ajustés, ont été prises par l’expérimentateur(trice) (une photographie du corps entier de face, une du corps entier de profil, et une photographie de votre visage). Ces photographies sont enregistrées uniquement dans l’appareil portable qui vous a été remis. Aucune exportation de ces images n’est possible, ni aucune consultation par une autre personne que vous. Ces photographies seront automatiquement effacées lorsque les scores seront exportés de l’application le dernier jour de l’expérience.\n\nPour toute question, contactez: axelle.nougal.etu@univ-lille.fr",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
