import 'package:flutter/material.dart';
import 'package:memory_app/Jeu/game_logic.dart';
import 'package:memory_app/utils.dart';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApprentissageScreen extends StatefulWidget {
  const ApprentissageScreen({super.key});

  @override
  _ApprentissageScreenState createState() => _ApprentissageScreenState();
}

class _ApprentissageScreenState extends State<ApprentissageScreen> {
  List<String> neutralImages = [
    'assets/neutres/horloge.jpg',
    'assets/neutres/lanterne.jpg',
    'assets/neutres/livre.jpg',
    'assets/neutres/outils.jpg',
    'assets/neutres/porte.jpg',
    'assets/neutres/pot.jpg',
    'assets/neutres/puit.jpg',
    'assets/neutres/roue.jpg',
    'assets/neutres/balle.jpg',
    'assets/neutres/television.jpg',
    'assets/neutres/souris.jpg',
  ];

  List<String> nonMotsImages = [
    'assets/nonmots/AMPA.jpeg',
    'assets/nonmots/ASLE.jpeg',
    'assets/nonmots/EGLO.jpeg',
    'assets/nonmots/ELTI.jpeg',
    'assets/nonmots/ESNA.jpeg',
    'assets/nonmots/IPNO.jpeg',
    'assets/nonmots/OMCE.jpeg',
    'assets/nonmots/OTBO.jpeg',
    'assets/nonmots/UNRE.jpeg',
  ];

  List<String> userImages = [];
  List<String> nonUsed = [];
  String group = "controle";

  @override
  void initState() {
    super.initState();
    checkGroup();
    _loadUserImages();
  }
  Future<void> checkGroup() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      group = prefs.getString('appMode') ?? 'controle';
    });}

  Future<void> _loadUserImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final files = Directory(path).listSync();

    final loadedImages = files
        .where((file) => file.path.endsWith('.jpg'))
        .map((file) => file.path)
        .toList();

    for (String imagePath in loadedImages) {
      FileImage(File(imagePath)).resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((_, __) {
          // Image successfully preloaded
        }),
      );
    }

    setState(() {
      userImages = loadedImages;
    });
  }


  List<Map<String, String>> _generatePairs() {

    final random = Random();
    List<Map<String, String>> pairs = [];
    List<String> selectedNeutralImages = neutralImages..shuffle(random);
    List<String> selectedUserImages = userImages..shuffle(random);
    List<String> selectedNonMotsImages = nonMotsImages..shuffle(random);
    for (int i = 0; i < 3; i++) {
      pairs.add({
        'neutral': selectedNonMotsImages[i],
        'user': group=="test"?selectedUserImages[i]:selectedNeutralImages[i],
      });
    }
    for (int i = 3; i < selectedNonMotsImages.length; i++) {
      setState(() {
        nonUsed.add(selectedNonMotsImages[i]);
      });
    }


    return pairs;
  }

  @override
  Widget build(BuildContext context) {
    final pairs = _generatePairs();
    return Scaffold(
      backgroundColor: ColorPalette.surface,
      appBar: AppBar(
        title: const Text("APPRENTISSAGE"),
        backgroundColor:ColorPalette.primary,
        foregroundColor: ColorPalette.onPrimary,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Mémorisez les trois paires ci-dessous.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorPalette.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: pairs.map((pair) => _buildPairRow(pair)).toList(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameLogicScreen(
                        initialPairs: pairs.expand((map) => map.values).toList(),
                        allImages: nonUsed
                      )
                  ),
                );
              },
              style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all<Size>(Size(Dimension.width * 0.33, Dimension.height * 0.02)),
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
                  'DEMARRER',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPairRow(Map<String, String> pair) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0.015*Dimension.height, 0, 0.015*Dimension.height,),
      child: Container(
        decoration: BoxDecoration(
          color: ColorPalette.secondary,
          borderRadius: const BorderRadius.all(
            Radius.circular(15.0)
          ),
        ),
        width: 0.8*Dimension.width,
        height: 0.2*Dimension.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildImageBox(pair['user']!),
            const SizedBox(width: 16),
            _buildImageBox(pair['neutral']!),
          ],
        )

      ),
    );
  }

  Widget _buildImageBox(String imagePath) {
    return Container(
      width: 0.165*Dimension.height,
      height: 0.165*Dimension.height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: imagePath.startsWith('assets')
              ? AssetImage(imagePath) as ImageProvider
              : FileImage(File(imagePath)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}