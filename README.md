# 6-7 Invasion

A clicker-style meme game built with Flutter and Flame engine.

## Overview

"6-7 Invasion" is a humorous tap-based mobile/web game where players spread the "6-7" meme to grow their influence and unlock new locations. Tap to generate energy, purchase upgrades, unlock locations, and face resistance events!

## Features

### Sprint 1 - Foundation ✅
- **Core Tapping Mechanics**: Tap anywhere to generate 6-7 Energy
- **Particle Effects**: Beautiful burst animations on each tap
- **Upgrade System**: JSON-driven upgrades with tap multipliers and passive generators
- **Passive Income**: Auto-generators that produce energy per second
- **Auto-Save**: Game progress saved automatically every 10 seconds
- **Persistent State**: Load your saved game on restart

### Sprint 2 - Content & Progression ✅
- **Location Progression**: Automatic advancement through 4 locations (Classroom → Gym → Street → Internet)
- **Dynamic Backgrounds**: Color-coded backgrounds that change per location
- **Progress Tracking**: Visual saturation bar showing progress to next location
- **Resistance Events**: Random timed events that affect gameplay (4 types implemented)
- **Event Notifications**: Real-time UI alerts for active resistance events
- **Character Sprites**: Emoji-based NPCs that react to location changes
- **Enhanced UI**: Polished overlays with better information display
- **8 Upgrades**: Complete upgrade tree with progression requirements

## Project Structure

```
lib/
├── game/                    # Flame game engine code
│   ├── components/         # Game components (particles, sprites)
│   ├── systems/            # Game systems (passive gen, upgrades)
│   └── six_seven_game.dart # Main game class
├── models/                  # Data models
│   ├── game_state.dart     # Core game state
│   ├── upgrade.dart        # Upgrade definitions
│   ├── location.dart       # Location definitions
│   └── resistance_event.dart # Event definitions
├── services/                # Services layer
│   ├── save_service.dart   # Persistence
│   ├── audio_service.dart  # Sound effects
│   └── game_config_service.dart # JSON config loader
├── ui/                      # Flutter UI overlays
│   ├── overlays/           # Game overlays
│   └── widgets/            # Reusable widgets
├── config/                  # JSON configuration files
│   ├── upgrades.json       # Upgrade definitions
│   ├── locations.json      # Location definitions
│   └── events.json         # Event definitions
├── utils/                   # Utility classes
└── main.dart               # App entry point
```

## Setup Instructions

### Prerequisites

- Flutter SDK 3.2.0 or higher
- Dart 3.2.0 or higher

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd sixseveninvasion
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # Web
   flutter run -d chrome

   # Android
   flutter run -d android

   # iOS
   flutter run -d ios
   ```

### Adding Assets

The game requires the following assets (currently placeholders):

- **Sound Effects** (assets/sounds/):
  - tap.mp3
  - purchase.mp3
  - event.mp3
  - unlock.mp3

- **Background Images** (assets/images/):
  - bg_classroom.png
  - bg_gym.png
  - bg_street.png
  - bg_internet.png

## Development Roadmap

### Sprint 1 - Foundations & Core Loop ✅
- [x] Initialize Flutter + Flame project
- [x] Create base FlameGame structure
- [x] Implement global game state
- [x] Add tap detection and particle animations
- [x] Display energy counter
- [x] Implement passive generators framework
- [x] Add shop UI and upgrade panel
- [x] Build JSON-driven upgrade system

### Sprint 2 - Content, Upgrades & Progression ✅
- [x] Add 5-8 complete upgrade definitions (8 upgrades implemented)
- [x] Implement location progression system
- [x] Add location saturation bar
- [x] Implement background swap per location
- [x] Add character/NPC sprites (emoji-based)
- [x] Add resistance event system
- [x] Implement 4 resistance events (all defined)
- [x] Add sound effects integration
- [x] Improve UI layout

### Sprint 3 - Polishing, Prestige & MVP Launch (Week 3)
- [ ] Implement Prestige ("Clout") system
- [ ] Add Clout permanent upgrades
- [ ] Add title screen + settings panel
- [ ] Add sound/vibration toggles
- [ ] Add tutorial/onboarding
- [ ] Improve animations
- [ ] Add 2 more resistance events
- [ ] Add 2 more locations
- [ ] Performance optimization
- [ ] Bug fixing and polish

### Sprint 4 - Optional Enhancements (Post-MVP)
- [ ] Meme Storm mini-game
- [ ] Daily quests
- [ ] Cosmetic items/skins
- [ ] Leaderboards
- [ ] Social sharing
- [ ] Monetization (optional)

## Game Balance

All game balance values are configurable via JSON files in `lib/config/`:

- **upgrades.json**: Define costs, effects, and unlock requirements
- **locations.json**: Set saturation thresholds and backgrounds
- **events.json**: Configure event effects and durations

## Architecture Notes

- **State Management**: Uses Provider pattern with ChangeNotifier
- **Persistence**: SharedPreferences for local save/load
- **Game Loop**: Flame engine handles rendering and updates at 60 FPS
- **Configuration**: JSON-driven for easy game balance tweaking

## Contributing

See the task planner in `docs/task_planner.md` for sprint breakdowns and tasks.

## License

[Add license information]
