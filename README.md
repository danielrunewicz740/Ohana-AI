# Ohana AI — Dog Training Check-In Kiosk

A Flutter **kiosk** app for Ohana Dog Training (San Diego, CA). Staff place this on a tablet at the front desk so dog owners can check in themselves.

## Features

| Feature | Detail |
|---|---|
| **Ohana character** | Cute large-headed Corgi/Border Collie mix, centered at the top |
| **Rive animation** | `idle_sitting` → `walking_forward` → `turning_around` states |
| **Welcome bubble** | Rotating friendly messages from Ohana |
| **Dog profiles** | Anubis, Rex, Buddies, Luna, Mochi, Daisy — each with a **Check-In** button |
| **Emergency Contact** | Large pulsing button that shows trainer & vet numbers |
| **Live clock** | Displayed in the header |

## Tech Stack

- **Flutter** ≥ 3.0
- **rive** ^0.13 — character animation
- **google_fonts** ^6.2 — Nunito typeface

## Getting Started

```bash
flutter pub get
flutter run
```

### Adding the Ohana Rive file

Drop `ohana.riv` into `assets/animations/`. See [`assets/animations/README.md`](assets/animations/README.md) for the required state-machine structure.

When the file is absent the app automatically renders a custom-painted cartoon placeholder with a gentle bounce animation.

## Project Structure

```
lib/
  main.dart                   # App entry point
  theme/app_theme.dart        # AppColors + AppTheme
  models/dog_profile.dart     # DogProfile model + default data
  screens/kiosk_screen.dart   # Main kiosk screen
  widgets/
    ohana_animation_widget.dart  # Rive character + painted fallback
    welcome_bubble.dart          # Speech-bubble greeting
    dog_profile_card.dart        # Per-dog check-in card
    emergency_contact_button.dart
assets/
  animations/ohana.riv        # (add your own)
  images/                     # Optional dog photos
test/
  widget_test.dart            # Widget & unit smoke tests
```

## Color Palette

| Name | Hex | Usage |
|---|---|---|
| Ocean Blue | `#1A6B8A` | Primary / header |
| Sand | `#F5E6C8` | Background |
| Seafoam | `#4CAF7D` | Check-In button |
| Coral | `#E85D3A` | Emergency button |
| Sun Gold | `#F4AB1C` | Accent |
| Cream | `#FFF8EE` | Cards / bubbles |
