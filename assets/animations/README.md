# Ohana Rive Animation Asset

Place `ohana.riv` in this directory.

## Rive file requirements

The Rive file must contain:

- **Artboard**: `Ohana`
- **State Machine**: `OhanaStateMachine`
- **Boolean inputs**:
  - `isWalking` — triggers the `walking_forward` state when `true`
  - `isTurning` — triggers the `turning_around` state when `true`
  - Both `false` → `idle_sitting` state

## Animation states

| State             | Trigger condition                    |
|-------------------|--------------------------------------|
| `idle_sitting`    | Default / both inputs false          |
| `walking_forward` | `isWalking = true`                   |
| `turning_around`  | `isTurning = true`                   |

## Visual design notes

Ohana is a cute, large-headed Corgi/Border Collie mix with warm brown fur,
a white chest blaze, pointed ears, and bright expressive eyes.
She is bright, bubbly, and uses her real-life colors.

When the Rive asset is absent the app automatically renders a custom-painted
cartoon placeholder with the same visual identity and a gentle bounce
animation.
