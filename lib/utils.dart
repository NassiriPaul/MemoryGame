import 'dart:ui';
import 'package:flutter/material.dart';

class ColorPalette {
  static Color primary = const Color.fromARGB(255, 156, 35, 126);
  static Color onPrimary = const Color.fromARGB(255, 255, 255, 255);
  static Color secondary =  const Color.fromARGB(255, 200, 200, 200);
  static Color onSecondary =  const Color.fromARGB(255, 0, 0, 0);
  static Color surface = const Color(0xFF2C3E50);
  static Color onSurface = const Color.fromARGB(255, 255, 255, 255);
}

class PresetText {
  static String consigneCapturePhotos = "Avant de pouvoir commencer à jouer, vous devez prendre les photos qui seront utilisées pendant le jeu. Vous aurez 3 photos à prendre. Pour cela, pressez le bouton 'Prendre photos' ci-dessous.";
  static String consigneModele = "Prenez une photo de la participante en respectant le modèle affiché à gauche.";
  static String consigneSoucis = "En cas de soucis, veuillez contacter axelle.nougal.etu@univ-lille.fr";
  static String consigneJeu = "Au début de chaque jeu, trois paires d'images vous seront présentées."
      "\n\nUne de ces paires apparaitra a chaque manche avec des distracteurs."
      "\n\nLors de chaque manche, votre but est de selectionner les deux images qui constituent une paire paire parmi les distracteurs aussi rapidement que possible !"
      "\n\nLe jeu est facile au début, mais progréssivement il va se compléxifier :"
      "\n\n- Lorsque vous aurez selectionné la première image, les autres seront noircies."
      "\n\n- Le nombre de distracteur va augmenter.";
}


class Dimension {
  // Méthode statique pour obtenir la taille logique de l'écran
  static Size get screenSize {
    FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;
    double pixelRatio = view.devicePixelRatio; // Facteur d'échelle
    Size physicalSize = view.physicalSize;
    return Size(
      physicalSize.width / pixelRatio,
      physicalSize.height / pixelRatio,
    );
  }

  // Largeur logique
  static double get width => screenSize.width;

  // Hauteur logique
  static double get height => screenSize.height;
}