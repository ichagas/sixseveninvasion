import 'package:flutter/material.dart';
import '../../services/save_service.dart';

/// Title screen shown on app launch
class TitleScreen extends StatelessWidget {
  final SaveService saveService;
  final VoidCallback onNewGame;
  final VoidCallback onContinue;

  const TitleScreen({
    super.key,
    required this.saveService,
    required this.onNewGame,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade900,
              Colors.purple.shade700,
              Colors.pink.shade600,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Title
              const Text(
                '6-7',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'INVASION',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Spread the meme. Gain the clout.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              // Buttons
              FutureBuilder<bool>(
                future: saveService.hasSave(),
                builder: (context, snapshot) {
                  final hasSave = snapshot.data ?? false;

                  return Column(
                    children: [
                      if (hasSave)
                        _buildButton(
                          'CONTINUE',
                          Icons.play_arrow,
                          Colors.green,
                          onContinue,
                        ),
                      const SizedBox(height: 16),
                      _buildButton(
                        'NEW GAME',
                        Icons.add,
                        Colors.blue,
                        onNewGame,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
              // Version
              Text(
                'v0.3.0 - Sprint 3 MVP',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: 280,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: color.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
