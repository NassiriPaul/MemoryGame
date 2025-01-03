import 'package:flutter/material.dart';
import 'package:memory_app/Jeu/apprentissage_screen.dart';
import 'package:memory_app/utils.dart';

class ConsigneScreen extends StatefulWidget {
  const ConsigneScreen({super.key});

  @override
  State<ConsigneScreen> createState() => _ConsigneScreenState();
}

class _ConsigneScreenState extends State<ConsigneScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: ColorPalette.surface,
      appBar: AppBar(
        title: const Text("CONSIGNE"),
        backgroundColor:ColorPalette.primary,
        foregroundColor: ColorPalette.onPrimary,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Text(
              PresetText.consigneJeu,
              style: TextStyle(color: ColorPalette.onSurface, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              // Naviguer vers l'écran du jeu
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ApprentissageScreen()),
              );
            },
            style: ButtonStyle(
              fixedSize: WidgetStateProperty.all<Size>(Size(width * 0.33, height * 0.02)),
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
          SizedBox(
            height: 0.02 * height,
          )
        ],
      ),
    );
  }
}
