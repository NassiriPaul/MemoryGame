import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HiddenModeManager extends StatefulWidget {
  final Widget child;

  const HiddenModeManager({required this.child, Key? key}) : super(key: key);

  @override
  State<HiddenModeManager> createState() => _HiddenModeManagerState();
}

class _HiddenModeManagerState extends State<HiddenModeManager> {
  String currentMode = 'controle'; // Par défaut, mode contrôle
  int secretTapCount = 0; // Compteur pour accéder au menu caché

  @override
  void initState() {
    super.initState();
    _loadCurrentMode();
  }

  Future<void> _loadCurrentMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentMode = prefs.getString('appMode') ?? 'controle'; // Par défaut : mode contrôle
    });
  }

  Future<void> _switchMode(String newMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appMode', newMode);
    setState(() {
      currentMode = newMode;
    });
  }

  void _onSecretTap() {
    setState(() {
      secretTapCount++;
    });

    if (secretTapCount >= 6) {
      secretTapCount = 0; // Réinitialiser le compteur
      _showPasswordPrompt(); // Afficher la boîte de dialogue pour le mot de passe
    }
  }

  void _showPasswordPrompt() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mot de passe requis'),
          content: TextField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              border: OutlineInputBorder(),
            ),
            obscureText: true, // Masquer le texte pour un mot de passe
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fermer le dialogue
              },
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text == '30052003') {
                  Navigator.pop(context);
                  _showHiddenMenu(); // Afficher le menu caché
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mot de passe incorrect')),
                  );
                }
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  void _showHiddenMenu() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Changer de mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Mode actuel : $currentMode'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _switchMode('test');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mode groupe test activé.')),
                  );
                },
                child: Text('Passer en mode Test'),
              ),
              ElevatedButton(
                onPressed: () {
                  _switchMode('controle');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mode contrôle activé.')),
                  );
                },
                child: Text('Passer en mode Contrôle'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onSecretTap, // Détecte les clics pour activer le menu caché
      child: Stack(
        children: [
          widget.child,
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              "admin",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ), // Affiche discrètement le mode actif
          ),
        ],
      ),
    );
  }
}
