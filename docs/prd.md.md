# PRD – 6-7 Invasion (Simple Version)

## 1. Overview
“6-7 Invasion” is a clicker-style meme game built in Flutter + Flame. Players tap to spread the meme and manage upgrades to grow faster.

## 2. Functional Requirements
### 2.1 Core Gameplay
- User taps anywhere to generate energy.
- Energy increments displayed in real time.
- Tap effects: burst animation + sound.

### 2.2 Upgrades
- Upgrade list view with cost + benefit.
- Auto-generators that produce energy per second.
- Locked upgrades until location progress is met.

### 2.3 Progression
- Each location requires a specific “meme saturation” level.
- Unlock new backgrounds + characters when advancing.

### 2.4 Resistance Events
- Random timed events that reduce production.
- Player interaction required to counter or wait it out.

### 2.5 Prestige System
- After final location, player resets for permanent “Clout” boost.

## 3. Non-Functional Requirements
- Smooth 60fps animations.
- Load within 3 seconds.
- Offline play supported.

## 4. Platforms
- Android  
- iOS  
- Web (Canvas/WebGL with Flame)

## 5. Open Questions
- Should monetization be included?
- Will social sharing be part of MVP?
