import 'package:flutter/material.dart';
import '../../services/audio_service.dart';
import '../../services/save_service.dart';
import '../../models/game_state.dart';

/// Settings panel
class SettingsPanel extends StatefulWidget {
  final AudioService audioService;
  final SaveService saveService;
  final GameState gameState;

  const SettingsPanel({
    super.key,
    required this.audioService,
    required this.saveService,
    required this.gameState,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white24, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.settings, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  'SETTINGS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Settings list
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildSwitchTile(
                  'Sound Effects',
                  Icons.volume_up,
                  widget.audioService.soundEnabled,
                  (value) {
                    setState(() {
                      widget.audioService.setSoundEnabled(value);
                    });
                  },
                ),
                const Divider(color: Colors.white24),
                _buildActionTile(
                  'Save Game',
                  Icons.save,
                  Colors.blue,
                  () {
                    widget.saveService.saveGame(widget.gameState);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Game saved!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white24),
                _buildActionTile(
                  'Reset Progress',
                  Icons.delete_forever,
                  Colors.red,
                  () => _showResetConfirmation(context),
                ),
                const SizedBox(height: 20),
                // Game info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '6-7 Invasion v0.3.0\nBuilt with Flutter + Flame\n\nA meme clicker game',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.green,
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontSize: 16),
      ),
      onTap: onTap,
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Text('Reset Progress?', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'This will permanently delete ALL progress including:\n\n'
          '• Energy and upgrades\n'
          '• Location progress\n'
          '• Clout and prestige upgrades\n'
          '• Statistics\n\n'
          'This action cannot be undone!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.saveService.deleteSave();
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close settings
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All progress deleted. Restart the app.'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('DELETE ALL'),
          ),
        ],
      ),
    );
  }
}
