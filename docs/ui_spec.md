# UI Specification — Prima Focus

Visual specifications aligned with the implemented design. Covers 5 screens + modals, design tokens, gesture model, micro-interactions, and accessibility guidelines.

---

## Design Philosophy

**Radical minimalism for neurodivergent brains.**
Every element on screen must earn its place. No decorative buttons, no visual noise. The app's core interaction model relies on gestures and context rather than multiple visible controls, reducing micro-decisions and cognitive load. Once gestures become muscle memory, the mental overhead drops to zero — a key outcome for users with ADHD.

---

## Visual Design System (Tokens)

### Color Palette — Dark Purple Glassmorphism
| Token | Value | Usage |
|---|---|---|
| `backgroundCenter` | `#1A103C` | Radial gradient center (top) |
| `backgroundEdge` | `#090514` | Radial gradient edge (bottom) |
| `glassSurface` | `#FFFFFF` at 7% alpha | Card/panel background |
| `glassBorderStart` | `#FFFFFF` at 25% alpha | Gradient border start |
| `glassBorderEnd` | `#FFFFFF` at 5% alpha | Gradient border end |
| `primaryAccent` | `#9D4DFF` (neon purple) | CTA buttons, FAB, active state |
| `primaryGlow` | `#7B2FBE` | Glow halos, active track fills |
| `accentGreen` | `#34C759` | Completion / "Yes" state |
| `accentOrange` | `#FF9F0A` | Partial completion state |
| `accentGray` | `#8E8E93` | Neutral / "No" state |
| `errorRed` | `#FF453A` | Delete swipe background |
| `textPrimary` | `#FFFFFF` | Titles and body text |
| `textSecondary` | `#FFFFFF` at 60% alpha | Metadata, hints, labels |
| `textDisabled` | `#FFFFFF` at 30% alpha | Disabled states |

### Typography
- **Font**: Roboto (Android system default).
- `headlineLarge`: 32sp, Bold — screen titles (Settings).
- `headlineMedium`: 28sp, SemiBold — task title on HomeScreen.
- `titleLarge`: 22sp, Bold — modal titles.
- `titleMedium`: 16sp, Bold — section labels.
- `bodyLarge`: 16sp, Regular — metadata, descriptions.
- `bodySmall`: 12sp, Regular — hints, subtitles.
- `labelSmall`: 10sp, Regular — badges, micro-labels.

> **Neurology note:** Avoid Thin/Light font weights on dark backgrounds. They force the brain to spend executive energy decoding the text. Use Regular or SemiBold as minimums for actionable content.

### Spacing & Layout
- Base grid: **8dp**.
- Card corner radius: **24dp** (large, friendly, reduces perceived sharpness).
- Card padding: **24–32dp** internal.
- Touch targets: **minimum 48×48 dp** on all interactive elements.
- FAB central: **80dp** diameter (primary action); **56dp** (secondary actions in modals).

### Glass Card Pattern
All cards and panels use the same "Fake Glassmorphism" pattern (no real blur, which would cause GPU lag):
```
Modifier
  .clip(RoundedCornerShape(24.dp))
  .background(glassSurface)   // White 7% alpha
  .border(
    1.dp,
    Brush.linearGradient([glassBorderStart → glassBorderEnd]),
    RoundedCornerShape(24.dp)
  )
```

---

## Gesture Model

> **Design Decision:** Buttons are replaced by swipe gestures on task cards to eliminate visual noise and reduce micro-decisions. This is neurologically sound for long-term use once the gesture becomes procedural memory.

| Gesture | Context | Action |
|---|---|---|
| Swipe Right → | HomeScreen task card | **Boost** priority (haptic + purple gradient reveal) |
| Swipe Left ← | HomeScreen task card | **Delete** task (haptic + red gradient reveal + Undo Snackbar) |

### Swipe Feedback (Required)
1. **Visual**: reveal a `horizontalGradient` beneath the card (purple for Boost, red for Delete), not a flat color.
2. **Icon**: large icon (40dp) appears on the revealed side (↑ for Boost, 🗑 for Delete).
3. **Haptic**: `HapticFeedbackType.LongPress` fires exactly when the swipe threshold is crossed — this creates a dopamine-triggering "snap" moment.
4. **Undo**: deleting always shows a Snackbar with "Deshacer" for 4 seconds.

### Discoverability
A subtle visual hint (e.g., a brief shimmer or bounce animation on first launch) signals that the task card is swipeable. A clear onboarding tooltip should appear on the first session.

---

## Screen 1: Ultra-Fast Inbox Modal

**Goal**: capture a task in ≤ 3 seconds.

### Layout
- **Container**: `ModalBottomSheet` with `scrimColor = Black at 70%` alpha, `RoundedCornerShape(topStart=24, topEnd=24)`.
- **Background**: `backgroundCenter` at 95% opacity (readable dark glass).
- **Top Row**:
  - `OutlinedTextField` (weight=1f): transparent background, neon purple focused border, placeholder "¿Qué tienes en mente?" at 50% alpha.
  - FAB circular 56dp on the right: `primaryAccent` background, Send icon. Replaces the old "Guardar / Cancelar" buttons.
- **Selectors Row**: `ExposedDropdownMenuBox` for Category and Subcategory side-by-side. `RoundedCornerShape(12dp)`, text in white, dropdown background in `backgroundEdge`.
- **Quick Dates & Optional Defaults**:
  - Two minimalist `FilterChip` buttons ("Hoy", "Mañana") to instantly set the due date.
  - Optional `OutlinedTextField` fields for Minutes and Subtasks that inherit global defaults from Settings if left empty. Entering "0" in Minutes explicitly disables timing.

### Removed from original spec
- ~~Mic icon / voice input~~ (discarded feature).
- ~~"Más detalles" accordion~~ — category/subcategory are always visible.
- ~~Cancelar text button~~ — replaced by swipe-down-to-dismiss.

---

## Screen 2: Today Task Home

**Goal**: show exactly 1 priority task. Zero navigation decisions required.

### Layout
- **Background**: `Brush.radialGradient([backgroundCenter → backgroundEdge])` drawn behind the full screen.
- **Top Bar**: "HOY" label (white 60%) + sync status icon (right). Minimal.
- **Task Card (center)**: Glass card pattern. Contains:
  - **Priority Badge (Pill)**: centered at top. Shows `Score: XX`. Error tint if score ≥ 70.
  - **Project Warning**: Yellow banner stating "Proyecto grande — dividir en subtareas" if `isProject` is true (estimated > 120m).
  - **Task Title**: `headlineMedium`, white, max 2 lines with ellipsis.
  - **Meta Row**: `category - subcategory • XX min` in `textSecondary`. If task has subtasks, shows a minimal "+X más" label instead of visual checkboxes.
  - **Start FAB**: 80dp circle, `primaryAccent` bg, Play icon 40dp. "EMPEZAR" label below (bold, spaced).
  - **Secondary Actions**: A minimalist row of transparent icon buttons (Editar, Posponer) rendered discreetly under the EMPEZAR label.
- **Empty State**: centered text "Tu Tarea Hoy aparecerá aquí" at 50% alpha.

### Removed from original spec
- ~~Subtasks inline checkboxes~~ — simplified into a pure text label (`+X más subtareas`).
- ~~Day progress (X/Y completadas)~~ — removed to reduce cognitive load.
- ~~Boost IconButton~~ — replaced by Swipe Right gesture.

---

## Screen 3: Timer (Pomodoro)

**Goal**: total immersion. Zero distractions during focus session.

### Layout
- **Background**: same radial gradient, static (does not recompose with the timer to protect GPU/battery).
- **Timer ring**: large `Canvas`-drawn circular arc (220dp+), progress in `primaryAccent`/`primaryGlow`, rail in glass white.
- **Time display**: `headlineLarge` centered. White.
- **Task name**: `bodyLarge` above the ring, white 80% alpha.
- **Controls**: two buttons below ring — Pausa (outline style) and Terminé (`accentGreen`).
- **Completion**: 600ms confetti animation + open QuickReviewModal.

### Performance Rule (Android Architect)
The timer counter **must be isolated** from the background layer. Only the text/arc pixels recompose each second. Background renders once per composition using `drawBehind`.

---

## Screen 4: Post-Session Quick Review Modal

**Goal**: 2 quick questions. No friction.

### Layout
- **Container**: same BottomSheet pattern as Inbox. `scrimColor = Black at 70%`. Drag handle white 30% alpha.
- **Title**: "Revisión Rápida", `titleLarge`, white.
- **Q1 — Completion**: 3 `StatusButton`s side-by-side (100×48dp):
  - Sí → `accentGreen` when selected.
  - Parcial → `accentOrange` when selected.
  - No → `accentGray` when selected.
  - Unselected state: `glassSurface` bg + `glassBorderStart` border.
- **Q2 — Feeling**: 3 EmojiButtons (56dp square). Selected state: `primaryGlow` at 30% bg + `primaryAccent` border.
- **Conditional Glass Panel** (Parcial/No): glass card appears with "¿Posponer o dividir?" and two text buttons.
- **Save Button**: full-width 56dp, `primaryAccent`, `RoundedCornerShape(16dp)`. Disabled until both questions answered (`primaryAccent` at 30% alpha when disabled).

---

## Screen 5: Recurrence and Settings

**Goal**: configure priority engine rules. Grouped for clarity.

### Layout
- **Background**: same radial gradient.
- **Title**: "Ajustes", `headlineLarge`, white, left-aligned.
- **Sections**: each section is a **glass panel** (`GlassCard` pattern, 24dp radius, `glassSurface` bg).
  1. **Valores por Defecto de Creación**: Scrollable row of `FilterChip` options for default minutes (including "0" for No Time) and default subtasks count.
  2. **Frecuencia de Notificaciones**: Scrollable row of `FilterChip` options (Apagadas, 15m, 30m, 1h, 2h).
  3. **Recurrencia por defecto**: FilterChips (Diaria, Semanal, Mensual) — transparent bg, `glassBorderStart` border.
  4. **Motor de Prioridades**: Auto-split `Switch` + Manual Boost `Slider` inside same panel. Divider between them: `glassBorderStart` 1dp line.
  5. **Reglas No-Posponibles**: Checkboxes for Salud→Medicación and Trámites→Urgente.
  6. **Categorías Activas**: List of all master categories with `Switch` controls to hide them from the Inbox.
- **Custom Controls**:
  - `Switch`: thumb `primaryAccent`, track `primaryGlow` at 30%, unchecked track/thumb white.
  - `Checkbox`: checked `primaryAccent`, checkmark white.
  - `Slider`: thumb `primaryAccent`, active track `primaryGlow`, inactive track `glassSurface`.
- **Save Button**: full-width 56dp, `primaryAccent`, `RoundedCornerShape(16dp)`.

---

## Accessibility & Neurodiversity Guidelines

> Guidelines for users with attention and focus challenges.

1. **Contrast**: all body text must meet WCAG AA (4.5:1 ratio minimum). Glass backgrounds must not reduce text contrast below this threshold.
2. **Touch Targets**: minimum 48×48dp on all interactive elements. FAB central ≥ 80dp.
3. **Semantic Actions**: add `Modifier.semantics { customActions = listOf(...) }` to swipeable cards so screen readers (TalkBack) can announce "Boost" and "Delete" as accessible actions.
4. **Font weights**: no Thin or Light weights on dark backgrounds. Minimum Regular (400).
5. **Haptic Feedback**: required on gesture threshold crossing — provides sensory confirmation critical for users with attention difficulties.
6. **Error Recovery**: every destructive action (delete) must be reversible via Snackbar Undo within 4 seconds.
7. **Onboarding**: a one-time visual hint (shimmer or tooltip) must signal swipe affordance on first launch. Gestures must be discoverable, not assumed.

---

## Pre-Implementation Checklist

- [x] Dark Purple Glassmorphism design system (`Color.kt`, `Theme.kt`, `LocalPremiumGlows`).
- [x] HomeScreen: radial gradient bg, glass task card, swipe gestures.
- [x] TimerScreen: isolated recomposition, circular ring, immersive layout.
- [x] InboxModal: dark glass bottomsheet, scrim 70%, FAB send button.
- [x] QuickReviewModal: dark glass bottomsheet, scrim 70%, custom status/emoji buttons.
- [x] SettingsScreen: glass panel groupings, custom switch/checkbox/slider colors.
- [x] HapticFeedback on swipe threshold.
- [x] Snackbar Undo on task delete.
- [ ] Swipe affordance onboarding hint (first-launch shimmer/tooltip).
- [ ] `Modifier.semantics` custom actions for TalkBack accessibility on task card.
