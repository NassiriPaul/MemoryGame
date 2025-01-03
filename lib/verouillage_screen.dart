import 'package:flutter/material.dart';
import 'package:memory_app/game_menu_screen.dart';
import 'package:memory_app/hidden_mode_screen.dart';
import 'package:memory_app/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  _LockScreenPageState createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  // Liste des chiffres tapés
  List<String> enteredDigits = [];

  // Longueur maximale du code
  final int maxCodeLength = 4;

  // Mode : saisie du code ou première définition
  bool isSettingCode = false;
  List<String>? newCode; // Stockage temporaire pour le code à définir
  String? savedCode; // Code sauvegardé dans SharedPreferences

  @override
  void initState() {
    super.initState();
    _checkIfCodeExists();
  }

  Future<void> _checkIfCodeExists() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedCode = prefs.getString('savedCode');
      isSettingCode = savedCode == null; // Mode définition uniquement si aucun code n'existe
    });
  }

  Future<void> _saveNewCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedCode', code);
    setState(() {
      savedCode = code;
      isSettingCode = false; // Désactiver le mode définition après la première fois
    });
  }

  void onDigitPressed(String digit) {
    if (enteredDigits.length < maxCodeLength) {
      setState(() {
        enteredDigits.add(digit);
      });
    }
  }

  void onDelete() {
    if (enteredDigits.isNotEmpty) {
      setState(() {
        enteredDigits.removeLast();
      });
    }
  }

  void onGo() {
    if (enteredDigits.length == maxCodeLength) {
      String code = enteredDigits.join();

      if (isSettingCode) {
        // Mode "définir le code"
        _saveNewCode(code);
        setState(() {
          newCode = null;
          enteredDigits.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votre code a été défini avec succès.')),
        );
      } else {
        // Mode "saisir le code"
        if (savedCode == code) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GameMenuScreen()),
          );
        } else {
          setState(() {
            enteredDigits.clear();
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Code incorrect. Réessayez.')),
          );
        }
      }
    }
  }

  Widget _buildDisplay(double w, double h) {
    if (enteredDigits.isEmpty) {
      return Container(
        width: w,
        height: h,
        margin: EdgeInsets.all(h * 0.25),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            isSettingCode
                ? (newCode == null ? "Définissez votre code" : "Confirmez votre code")
                : "Entrez votre code",
            style: TextStyle(
              fontSize: 100,
              color: ColorPalette.onSurface,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      );
    } else {
      String display = enteredDigits.map((_) => "•").join(" ");
      return Container(
        width: w,
        height: h,
        margin: EdgeInsets.all(h * 0.25),
        child: Text(
          display,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: w / 8,
            color: ColorPalette.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: ColorPalette.surface,
      body: SafeArea(
        child: HiddenModeManager(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDisplay(0.66 * width, 0.1 * height),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildKeypad(width * 0.23),
                  _buildBottomRow(width * 0.23),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad(double radius) {
    final digits = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < digits.length; i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: digits[i].map((d) {
              return _buildCircleButton(
                d,
                radius,
                ColorPalette.secondary,
                ColorPalette.onSecondary,
                onTap: () => onDigitPressed(d),
              );
            }).toList(),
          ),
          if (i < digits.length - 1) SizedBox(height: radius / 5),
        ],
        SizedBox(height: radius / 5),
      ],
    );
  }

  Widget _buildBottomRow(double radius) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCircleButton(
          "⌫",
          radius,
          ColorPalette.primary,
          ColorPalette.onPrimary,
          onTap: onDelete,
        ),
        _buildCircleButton(
          "0",
          radius,
          ColorPalette.secondary,
          ColorPalette.onSecondary,
          onTap: () => onDigitPressed('0'),
        ),
        _buildCircleButton(
          "GO",
          radius,
          ColorPalette.primary,
          ColorPalette.onPrimary,
          onTap: onGo,
        ),
      ],
    );
  }

  Widget _buildCircleButton(String text, double radius, Color bgColor, Color fgColor, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: radius,
        height: radius,
        child: Container(
          padding: EdgeInsets.all(radius / 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          alignment: Alignment.center,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 100,
                fontWeight: FontWeight.w300,
                color: fgColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
