import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'services/save_service.dart';
import 'services/audio_service.dart';
import 'services/game_config_service.dart';
import 'game/six_seven_game.dart';
import 'ui/overlays/energy_display.dart';
import 'ui/overlays/shop_panel.dart';
import 'ui/overlays/location_progress_bar.dart';
import 'ui/overlays/event_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  final saveService = SaveService();
  final audioService = AudioService();
  final configService = GameConfigService();

  // Load game configuration
  await configService.loadConfigs();

  // Try to load saved game
  GameState gameState = await saveService.loadGame() ?? GameState();

  runApp(
    SixSevenInvasionApp(
      gameState: gameState,
      saveService: saveService,
      audioService: audioService,
      configService: configService,
    ),
  );
}

class SixSevenInvasionApp extends StatelessWidget {
  final GameState gameState;
  final SaveService saveService;
  final AudioService audioService;
  final GameConfigService configService;

  const SixSevenInvasionApp({
    super.key,
    required this.gameState,
    required this.saveService,
    required this.audioService,
    required this.configService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gameState,
      child: MaterialApp(
        title: '6-7 Invasion',
        theme: ThemeData.dark(),
        home: GameScreen(
          gameState: gameState,
          saveService: saveService,
          audioService: audioService,
          configService: configService,
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final GameState gameState;
  final SaveService saveService;
  final AudioService audioService;
  final GameConfigService configService;

  const GameScreen({
    super.key,
    required this.gameState,
    required this.saveService,
    required this.audioService,
    required this.configService,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SixSevenGame game;

  @override
  void initState() {
    super.initState();

    game = SixSevenGame(
      gameState: widget.gameState,
      audioService: widget.audioService,
      configService: widget.configService,
      onEventTriggered: _onEventTriggered,
    );

    // Auto-save every 10 seconds
    _startAutoSave();

    // Listen for game state changes
    widget.gameState.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    widget.gameState.removeListener(_onGameStateChanged);
    widget.audioService.dispose();
    super.dispose();
  }

  void _startAutoSave() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        widget.saveService.saveGame(widget.gameState);
        _startAutoSave();
      }
    });
  }

  void _onGameStateChanged() {
    // Trigger UI rebuild when game state changes
    if (mounted) {
      setState(() {});
    }
  }

  void _onEventTriggered(String eventId) {
    // Force UI update when event triggers
    if (mounted) {
      setState(() {});
    }
  }

  void _showShop() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: ShopPanel(
          upgradeManager: game.upgradeManager,
          configService: widget.configService,
          audioService: widget.audioService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game canvas
          GameWidget(
            game: game,
          ),
          // Event notifications at top
          EventNotifications(
            configService: widget.configService,
          ),
          // UI Overlays
          SafeArea(
            child: Column(
              children: [
                // Energy display at top
                const EnergyDisplay(),
                // Location progress bar
                LocationProgressBar(
                  configService: widget.configService,
                ),
                const Spacer(),
                // Shop button at bottom
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Settings button (placeholder)
                      IconButton(
                        icon: const Icon(Icons.settings),
                        iconSize: 32,
                        color: Colors.white,
                        onPressed: () {
                          // TODO: Show settings panel
                        },
                      ),
                      // Shop button
                      ElevatedButton.icon(
                        onPressed: _showShop,
                        icon: const Icon(Icons.shopping_cart),
                        label: const Text('SHOP'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow.shade700,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
}
