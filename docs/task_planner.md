# Task Planner – 6-7 Invasion
Project structure broken down into development sprints (1-week cycles).  
Goal: ship a minimal playable MVP by the end of Sprint 3.

---

# 🌱 Sprint 1 – Foundations & Core Loop (Week 1)

## Goals
Set up project skeleton, core tapping loop, basic UI overlays, and first energy system.

## Tasks
- Initialize Flutter + Flame project
- Create base FlameGame structure
- Implement global game state (energy counter, per-second timers)
- Add tap detection anywhere on screen
- Implement basic particle burst animation on tap
- Display energy counter (Flutter overlay)
- Implement passive generators framework (timer-driven)
- Add first simple UI: basic shop button + placeholder panel
- Add placeholder assets (temporary icons + background)
- Build simple upgrade system (JSON-driven config)
- Add debug logs for event triggers

## Deliverables
- Basic playable tapper with energy generation
- Simple upgrade panel (no final UI)
- Code architecture validated

---

# 🚀 Sprint 2 – Content, Upgrades & Progression (Week 2)

## Goals
Add actual game content: upgrades, locations, and resistance events. Improve visuals and flow.

## Tasks
- Create 5–8 upgrade definitions (tap boosts + passive generators)
- Implement location progression system
- Add location saturation bar (progress toward next area)
- Implement background swap per location
- Add characters/NPC sprites (simple animations)
- Add resistance event system (timers + events queue)
- Implement at least 2 resistance events:
  - Teacher Silencer
  - Parent Lecture
- Add sound effects for taps and events
- Improve UI layout (Flutter overlays)
  - Shop panel
  - Location indicator
  - Energy per second indicator
- Add save/load (local preferences)

## Deliverables
- Fully functional clicker loop
- At least one resistance event integrated
- First two locations fully playable

---

# 🔥 Sprint 3 – Polishing, Prestige & MVP Launch (Week 3)

## Goals
Complete MVP: polish visuals, add prestige, and prepare for initial release.

## Tasks
- Implement Prestige (“Clout”) system
- Add Clout permanent upgrades (3–5 simple buffs)
- Add title screen + simple settings panel
- Add sound toggle / vibration toggle
- Add simple tutorials / onboarding text bubbles
- Improve animations (sprite movement, events popping in)
- Add 1–2 more resistance events:
  - Security Guard Chase
  - Anti-Meme Algorithm Suppression
- Add 1–2 additional locations (Gym, Street)
- Final visual theme polish (colors, icons)
- Performance testing + FPS optimization
- Final bug roundup and polish tasks

## Deliverables
- MVP playable from start → prestige
- All core features implemented
- Usable UI/UX

---

# ⭐ Sprint 4 – Optional Enhancements (Post-MVP)

## Optional Tasks (stretch goals)
- Add Meme Storm mini-game
- Implement daily quests
- Add skins or cosmetic items
- Add simple leaderboards (Firebase)
- Social share button (export meme screenshot)
- Add character reactions and idle animations
- Particle effects polish
- Monetization (if desired):
  - Remove ads
  - Starter pack
  - Cosmetic shop

## Deliverables
- Enhanced version ready for soft launch
- Analytics-ready build (optional)

---

# ✔ Final Notes

- Sprints follow a weekly cycle with daily builds.  
- MVP should be shippable after **Sprint 3**.  
- Sprint 4 is purely optional polish depending on timeline.  
