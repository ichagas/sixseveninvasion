# 6-7 Invasion - Quick Reference

## Current Status: ✅ MVP Complete (v0.3.0)

All 3 core sprints completed successfully!

---

## Running the Game

### Requirements
- Flutter SDK 3.2.0+
- Dart 3.2.0+

### Quick Start
```bash
cd sixseveninvasion
flutter pub get
flutter run -d chrome  # For web
```

---

## Game Flow

### 1. Title Screen
- **New Game** → Start fresh
- **Continue** → Load saved game

### 2. Main Game
- **Tap anywhere** → Generate energy
- **Shop button** → Buy upgrades
- **Star button** → Open prestige panel
- **Settings button** → Audio, save, reset

### 3. Progression Loop
1. Tap to generate energy
2. Buy upgrades (tap boost or passive generators)
3. Fill location saturation bar
4. Auto-advance to next location
5. Survive random resistance events
6. Reach location 1+ to unlock prestige
7. Prestige for Clout
8. Buy permanent Clout upgrades
9. Repeat with bonuses!

---

## Key Files

### Core Game
- `lib/main.dart` - App entry point, title screen, navigation
- `lib/game/six_seven_game.dart` - Main Flame game class
- `lib/models/game_state.dart` - All game state and logic

### Configuration (JSON)
- `lib/config/upgrades.json` - 8 regular upgrades
- `lib/config/clout_upgrades.json` - 5 prestige upgrades
- `lib/config/locations.json` - 4 locations
- `lib/config/events.json` - 4 resistance events

### UI Panels
- `lib/ui/screens/title_screen.dart` - Start screen
- `lib/ui/overlays/shop_panel.dart` - Upgrade shop
- `lib/ui/overlays/prestige_panel.dart` - Prestige/Clout system
- `lib/ui/overlays/settings_panel.dart` - Settings
- `lib/ui/overlays/energy_display.dart` - Energy counter
- `lib/ui/overlays/location_progress_bar.dart` - Progress bar
- `lib/ui/overlays/event_notifications.dart` - Event alerts

### Game Systems
- `lib/game/systems/passive_generator_system.dart` - Passive income
- `lib/game/systems/upgrade_manager.dart` - Upgrade logic
- `lib/game/systems/location_progression_system.dart` - Location unlocks
- `lib/game/systems/resistance_event_system.dart` - Random events

---

## Game Balance

### Upgrades
| Name | Type | Base Cost | Effect | Location |
|------|------|-----------|--------|----------|
| Finger Guns | Tap | 10 | +1/tap | 0 |
| Megaphone | Tap | 100 | +5/tap | 0 |
| Bot Army | Passive | 50 | 1/sec | 0 |
| Echo Chamber | Passive | 500 | 5/sec | 1 |
| Kids | Passive | 2000 | 10/sec | 1 |
| Viral Video | Tap | 5000 | +20/tap | 2 |
| Influencer | Passive | 10000 | 50/sec | 2 |
| Meme Factory | Passive | 50000 | 200/sec | 3 |

### Locations
| ID | Name | Saturation Required | Background |
|----|------|-------------------|-----------|
| 0 | Classroom | 500 | Beige |
| 1 | Gym | 5,000 | Blue |
| 2 | Street | 50,000 | Gray |
| 3 | Internet | 500,000 | Dark Purple |

### Clout Upgrades
| Name | Cost | Effect |
|------|------|--------|
| Tap Mastery | 1 | +50% tap power |
| Passive Empire | 1 | +50% passive income |
| Meme Lord | 2 | +25% all energy |
| Viral Legend | 5 | +100% all energy |
| Internet God | 10 | +200% all energy |

### Resistance Events
| Name | Effect | Duration | Min Location |
|------|--------|----------|-------------|
| Teacher Silencer | -50% tap power | 30s | 0 |
| Parent Lecture | Pause passive | 45s | 0 |
| Security Chase | -75% all income | 60s | 1 |
| Algorithm Suppression | +50% upgrade costs | 90s | 2 |

---

## Architecture Patterns

### State Management
- **Provider** pattern with `ChangeNotifier`
- `GameState` as single source of truth
- UI listens to state changes

### Persistence
- **SharedPreferences** for local storage
- JSON serialization
- Auto-save every 10 seconds
- Manual save button

### Configuration
- **JSON files** for game balance
- Easy to tweak without code changes
- Fallback defaults if JSON fails

### Game Loop
- **Flame engine** handles 60 FPS rendering
- Component-based architecture
- System-based game logic

---

## Modifying Game Balance

### To change upgrade costs/effects:
Edit `lib/config/upgrades.json`

### To adjust location requirements:
Edit `lib/config/locations.json`

### To modify event behavior:
Edit `lib/config/events.json`

### To tweak clout upgrades:
Edit `lib/config/clout_upgrades.json`

**Note:** Changes require app restart to take effect.

---

## Common Tasks

### Add a new upgrade
1. Add entry to `lib/config/upgrades.json`
2. Restart app
3. Upgrade appears in shop

### Add a new location
1. Add entry to `lib/config/locations.json`
2. Add background color in `BackgroundComponent`
3. Add emoji set in `CharacterComponent`

### Add a new resistance event
1. Add entry to `lib/config/events.json`
2. Event triggers automatically

### Change prestige formula
Edit `GameState.calculateCloutGain()` in `lib/models/game_state.dart`

---

## Testing Tips

### Quick Testing
1. Reduce location saturation to 50 (in `locations.json`)
2. Reduce upgrade costs (in `upgrades.json`)
3. Increase tap power to 100
4. Test prestige quickly

### Reset Save
- Use Settings → Reset Progress
- Or delete SharedPreferences manually

### Debug Mode
- Check console for event triggers
- Use debug overlay in Flame

---

## Known Issues

### Assets
- No actual image files (using colored backgrounds)
- No actual sound files (silent on missing files)
- Using emoji for characters (functional placeholder)

### Not Implemented
- Tutorial/onboarding
- Vibration feedback
- Advanced animations
- Mini-games
- Leaderboards

---

## Repository Structure

```
Branches:
├── sprint-1-foundations (complete)
├── sprint-2-content (complete)
├── sprint-3-mvp (complete)
├── sprint-4-optional (ready)
└── claude/review-docs-planning-01WDg1aGjWYnXiYkuwLgyk92 (main dev)

Commits:
- Complete Sprint 1: Foundations & Core Loop
- Complete Sprint 2: Content, Upgrades & Progression
- Complete Sprint 3: Polishing, Prestige & MVP Launch
- Add MVP development summary documentation
```

---

## Performance Notes

### Optimization
- Particle system uses efficient rendering
- Background component updates only on location change
- Event cleanup runs each frame
- Auto-save throttled to 10 seconds

### Potential Improvements
- Object pooling for particles
- Sprite caching
- Batch rendering
- Reduce state notifications

---

## Next Development Priorities

### High Priority
1. Add actual image assets
2. Add actual sound effects
3. Test on physical devices
4. Performance profiling

### Medium Priority
1. Tutorial system
2. Better animations
3. Balance tweaking
4. Bug fixes

### Low Priority
1. Cosmetic features
2. Social features
3. Leaderboards
4. Monetization

---

**Last Updated:** Sprint 3 Complete
**Version:** 0.3.0 MVP
**Status:** Fully Playable
