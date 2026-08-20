# UI Specification — Prima Focus

Visual specifications aligned with the implemented design. Covers 5 screens + modals, design tokens, gesture model, micro-interactions, and accessibility guidelines.

---

## Design Philosophy

**Radical minimalism for neurodivergent brains.**
Every element on screen must earn its place. No decorative buttons, no visual noise. The app's core interaction model relies on gestures and context rather than multiple visible controls, reducing micro-decisions and cognitive load. Once gestures become muscle memory, the mental overhead drops to zero — a key outcome for users with ADHD.

## Responsive & Tablet Layout (WindowSizeClass)

**Goal**: Optimize screen real estate for larger form factors without compromising the minimal aesthetic.

### Layout Modalities
- **Compact (Phones)**: Standard vertical flow.
- **Expanded (Tablets)**: Implements a Split View architecture.
  - **Left Pane (Navigation & Filters)**: Features a custom Interactive Calendar to visually filter tasks by date.
  - **Right Pane (Content)**: Displays the focused task card or the Inbox modal content directly without obscuring the calendar context.

> **Neurology Note:** Providing spatial memory through a fixed calendar pane on tablets reduces cognitive load compared to hiding filters behind menus or modals.

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
- **Selectors Column**: `ExposedDropdownMenuBox` for Category and Subcategory stacked vertically. `RoundedCornerShape(12dp)`, text in white, dropdown background in `backgroundEdge`.
- **Dates**:
  - `FilterChip` buttons ("Hoy", "Mañana", "Siguiente Lunes") to instantly set the due date.
  - An "Elegir fecha" `FilterChip` that opens a native `DatePickerDialog`.
  - Tasks without a selected date are sent to the backlog unprogrammed.
- **Atomic Task Creation**: No time or duration inputs are required; tasks are saved directly as actionable atomic items.

### Removed from original spec
- ~~Mic icon / voice input~~ (discarded feature).
- ~~"Más detalles" accordion~~ — category/subcategory are always visible.
- ~~Duration chips & minutes input~~ — removed to prevent cognitive fatigue and time estimation friction.
- ~~Cancelar text button~~ — replaced by swipe-down-to-dismiss.

---

## Screen 2: Today Multi-Focus Home

**Goal**: Present the Top 3 prioritized tasks with high visual hierarchy and direct atomic completion, plus an expandable cluster for tied priorities.

### Layout
- **Background**: `Brush.radialGradient([backgroundCenter → backgroundEdge])` drawn behind the full screen.
- **Top Bar**: "HOY" label (white 60%, letter-spaced) + sync status icon (right).
- **Hero Task Card (#1, center)**: Glass card pattern with radial glow. Contains:
  - **Priority Badge**: Urgente, Alta, Normal, Baja.
  - **Boost Indicator**: displays active manual boost (e.g., `(+10 boost)` or `(-10 boost)`).
  - **Task Title**: `headlineSmall`, bold, white, up to 3 lines without truncation.
  - **Meta Row**: `category - subcategory • Date` in `textSecondary`.
  - **Expandable Notes**: clean button ("Ver notas" / "Ocultar notas") revealing multiline context without cluttering the initial card view.
  - **Complete FAB**: 80dp circle, `primaryAccent` bg, Checkmark icon 40dp with "COMPLETAR" label below (bold, spaced) and instant Undo Snackbar support.
  - **Action Row**: Edit, Snooze, Boost (+10), Anti-Boost (-10), Delete.
- **Secondary Cards (#2 & #3)**: Compact glass cards with `#2` and `#3` rank badges, direct checkmark completion, expandable notes, and action buttons.
- **Expandable Tied Priority Cluster**: When subsequent tasks share priority with the 3rd card, a `+N tareas con igual prioridad` banner expands inline.

---

## Screen 3: Timer (Pomodoro)

**Goal**: total immersion. Zero distractions during focus session.

### Layout
- **Background**: same radial gradient, static (does not recompose with the timer to protect GPU/battery).
- **Timer ring**: large `Canvas`-drawn circular arc (220dp+), progress in `primaryAccent`/`primaryGlow`, rail in glass white.
- **Time display**: `headlineLarge` centered. White.
- **Task name**: `bodyLarge` above the ring, white 80% alpha.
- **Controls**: two buttons below ring — Pausa (outline style) and Terminé (`accentGreen`).
- **Completion Flow**:
  - If `isHistoryTrackingEnabled == true`: 600ms celebration + open `QuickReviewModal`.
  - If `isHistoryTrackingEnabled == false`: Direct task completion with instant return to Home (zero friction).

---

## Screen 4: Post-Session Quick Review Modal (Optional)

**Goal**: 2 quick reflective questions when History & Review mode is enabled.

### Layout
- **Container**: same BottomSheet pattern as Inbox. `scrimColor = Black at 70%`. Drag handle white 30% alpha.
- **Title**: "Revisión Rápida", `titleLarge`, white.
- **Q1 — Completion**: 3 `StatusButton`s side-by-side (100×48dp):
  - Sí → `accentGreen` when selected.
  - Parcial → `accentOrange` when selected.
  - No → `accentGray` when selected.
- **Q2 — Feeling**: 3 EmojiButtons (56dp square): 😢 (Mal), 😐 (Normal), 😄 (Bien).
- **Save Button**: full-width 56dp, `primaryAccent`, `RoundedCornerShape(16dp)`.

---

## Screen 5: Task List & Completed History Screen

**Goal**: comprehensive queue overview with optional completed history.

### Layout
- **Segmented Glassmorphic Tabs (Visible when History is enabled)**:
  - `[ Pendientes (N) ]` | `[ Historial (M) ]`
- **Pending Tasks Tab**:
  - Multi-line titles (up to 3 lines), category badges, expandable notes, Boost (+10), Demote (-10), Edit, Snooze, Delete with 4-second Undo Snackbar.
- **Completed History Tab**:
  - Header with total count and "Vaciar Historial" button (opens confirmation dialog).
  - List of completed task cards displaying completion timestamp (`Hoy, 14:30`), minutes dedicated, sentiment emoji badge (`• 😄`), "Reabrir Tarea" (↩) and Delete actions.

---

## Screen 6: Settings & Local Backup

**Goal**: configure priority rules, notification schedules, local backups, and history modes.

### Sections
1. **Frecuencia de Notificaciones**: Dropdown selector (Apagadas, 1h 30m, 3h, 5h).
2. **Modo Desconexión**: Time range picker for quiet hours.
3. **Categorías Activas**: Switches to show/hide specific categories in Inbox.
4. **Historial y Revisión de Tareas**: Switch to toggle between Zero-Friction mode and Reflective History mode.
5. **Copia de Seguridad Local (SAF)**: Exportar JSON and Restaurar JSON buttons (with Merge vs Overwrite dialog).
6. **Sincronización P2P (Local)**: Local device-to-device sync without internet.
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
