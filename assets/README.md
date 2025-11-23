# Assets Directory

This directory contains game assets including images, sounds, and fonts.

## Directory Structure

```
assets/
├── images/         # Background images and sprites
├── sounds/         # Sound effects and music
└── fonts/          # Custom fonts
```

## Required Assets

### Images (assets/images/)
- `bg_classroom.png` - Classroom background (800x600 recommended)
- `bg_gym.png` - Gym background (800x600 recommended)
- `bg_street.png` - Street background (800x600 recommended)
- `bg_internet.png` - Internet background (800x600 recommended)

**Note**: Currently using colored rectangles as placeholders. The BackgroundComponent will automatically display these when added.

### Sounds (assets/sounds/)
- `tap.mp3` - Sound when player taps (short, ~0.1s)
- `purchase.mp3` - Sound when purchasing upgrade (short, ~0.2s)
- `event.mp3` - Sound when resistance event triggers (medium, ~0.5s)
- `unlock.mp3` - Sound when unlocking new location (medium, ~0.5s)

**Note**: Sound files are optional. AudioService handles missing files gracefully.

### Fonts (assets/fonts/)
Custom fonts can be added here and configured in `pubspec.yaml`.

## Creating Placeholder Assets

### For Testing Without Assets:
The game is designed to work without assets:
- Backgrounds use solid colors per location
- Characters use emoji sprites
- Sounds fail silently if missing

### To Add Real Assets:
1. Create or download assets matching the specifications above
2. Place files in the appropriate directories
3. Update paths in JSON config files if needed (`lib/config/locations.json`)
4. Run `flutter pub get` to ensure assets are recognized
