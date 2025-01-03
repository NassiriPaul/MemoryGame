import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_app/app_state.dart';
import 'package:memory_app/game_menu_screen.dart';
import 'package:memory_app/utils.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class StepsScreen extends StatefulWidget {
  final List<String> modelImages;

  const StepsScreen({super.key, required this.modelImages});

  @override
  _StepsScreenState createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  int currentStep = 0; // Current step
  List<File?> photos = []; // List of photos taken

  @override
  void initState() {
    super.initState();
    photos = List<File?>.filled(widget.modelImages.length, null);
  }

  Future<void> _takePhoto() async {
    Provider.of<AppState>(context, listen: false).unlock();
    final ImagePicker picker = ImagePicker();
    final XFile? pickedPhoto = await picker.pickImage(source: ImageSource.camera);

    if (pickedPhoto != null) {
      setState(() {
        photos[currentStep] = File(pickedPhoto.path);
      });
    }

    // Attendre un court délai pour s'assurer que la caméra est bien fermée
    await Future.delayed(const Duration(milliseconds: 300));

    Provider.of<AppState>(context, listen: false).lock();
  }

  void _clearPhoto() {
    setState(() {
      photos[currentStep] = null;
    });
  }

  Future<void> _savePhotos() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      for (int i = 0; i < photos.length; i++) {
        if (photos[i] != null) {
          final file = photos[i]!;
          final path = '${directory.path}/photo_$i.jpg';
          await file.copy(path);

          // Save path in SharedPreferences
          prefs.setString('photo_$i', path);
        }
      }

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Photos enregistrées avec succès!"),
          duration: Duration(seconds: 2), // Duration of the snackbar
        ),
      );

      // Wait for the snackbar to finish before navigating
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to the game menu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const GameMenuScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de l'enregistrement des photos.")),
      );
    }

  }


  void _nextStep() {
    if (currentStep < widget.modelImages.length - 1) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: ColorPalette.surface,
      appBar: AppBar(
        title: Text("ETAPE ${currentStep + 1}/${widget.modelImages.length}"),
        backgroundColor:ColorPalette.primary,
        foregroundColor: ColorPalette.onPrimary,
        centerTitle: true,
        automaticallyImplyLeading: currentStep == 0, // Only show back button on first step
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              PresetText.consigneModele,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorPalette.onSurface, fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Model Image
                Column(
                  children: [
                    Container(
                      width: width * 0.33,
                      height: width * 0.33,
                      decoration: BoxDecoration(
                        color: ColorPalette.secondary,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(widget.modelImages[currentStep]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.01 * height),
                    Text("Modèle", style: TextStyle(color: ColorPalette.onSurface)),
                  ],
                ),
                // Captured Photo
                Column(
                  children: [
                    Container(
                      width: width * 0.33,
                      height: width * 0.33,
                      decoration: BoxDecoration(
                        color: ColorPalette.secondary,
                        borderRadius: BorderRadius.circular(10),
                        image: photos[currentStep] != null
                            ? DecorationImage(
                          image: FileImage(photos[currentStep]!),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: photos[currentStep] == null
                          ? Icon(Icons.image, color: ColorPalette.onSecondary, size: 80)
                          : null,
                    ),
                    SizedBox(height: 0.01 * height),
                    Text("Votre photo", style: TextStyle(color: ColorPalette.onSurface)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            photos[currentStep] == null
                ? TextButton(
              onPressed:  _takePhoto,
              style: TextButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                foregroundColor: ColorPalette.onPrimary,
                textStyle: const TextStyle(fontSize: 18),
                minimumSize: Size(width * 0.8, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Prendre une photo"),
            )
                : Column(
              children: [
                TextButton(
                  onPressed:  _takePhoto,
                  style: TextButton.styleFrom(
                    backgroundColor: ColorPalette.primary,
                    foregroundColor: ColorPalette.onPrimary,
                    textStyle: const TextStyle(fontSize: 18),
                    minimumSize: Size(width * 0.8, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Reprendre la photo"),
                ),
                TextButton(
                  onPressed: _clearPhoto,
                  style: TextButton.styleFrom(
                    backgroundColor: ColorPalette.secondary,
                    foregroundColor: ColorPalette.onSecondary,
                    textStyle: const TextStyle(fontSize: 18),
                    minimumSize: Size(width * 0.8, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Effacer l'image actuelle"),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentStep > 0 ? _previousStep : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorPalette.onPrimary,
                    backgroundColor: currentStep > 0
                        ? ColorPalette.primary
                        : Colors.grey,
                  ),
                  child: const Text("< PRECEDENT"),
                ),
                ElevatedButton(
                  onPressed: photos[currentStep] != null
                      ? (currentStep < widget.modelImages.length - 1
                      ? _nextStep
                      : _savePhotos)
                      : null,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ColorPalette.onPrimary,
                    backgroundColor: photos[currentStep] != null
                        ? ColorPalette.primary
                        : Colors.grey,
                  ),
                  child: Text(currentStep < widget.modelImages.length - 1
                      ? "SUIVANT >"
                      : "CONFIRMER"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
