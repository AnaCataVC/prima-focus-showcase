> **Created:** 2026-08-20
> **Last Updated:** 2026-08-20

# Research: Task Notes, Multi-Focus Expansion, SAF Local Backup, Anti-Boost & Input Sanitization

## 1. Context & Objectives
This document synthesizes the architectural decisions, API patterns, and UX trade-offs for:
1. Adding rich notes / descriptions to tasks (resolving title length truncation and supporting expandable details).
2. Multi-task presentation on `HomeScreen` (Top 3 prioritized tasks + inline expansion for tied-priority tasks).
3. Local Backup & Restore mechanism via Android Storage Access Framework (SAF) + data persistence safety across app updates.
4. Input sanitization for task duration (eliminating newline insertion and invalid number formats).
5. Non-priority task management (enabling edit, delete, undo, snooze across all screens).
6. Anti-boost / Demotion capability (symmetrical manual priority adjustments).

---

## 2. Technical Insights & Best Practices

### A. Android SAF Backup & Room Data Integrity
- **Export Flow**: `ActivityResultContracts.CreateDocument("application/json")` launches the native system file picker, allowing users to save their full backup file (e.g., `prima_focus_backup_20260820_120000.json`) locally or to cloud storage (Google Drive / Nextcloud / local SD).
- **Import Flow**: `ActivityResultContracts.OpenDocument()` with MIME type `application/json` or `*/*` retrieves a `Uri`. The app reads the stream, deserializes using Gson (`BackupDataPayload(version = 1, tasks = [...], sessions = [...])`), and executes an atomic `@Transaction` in Room (with merge / replace strategies).
- **Data Persistence across App Updates**:
  - Android retains `/data/data/<package_name>/databases/` across APK updates provided the signature / package name matches.
  - Room migrations MUST NOT call `fallbackToDestructiveMigration()` in production.
  - Explicit Room migrations ensure zero data loss during schema modifications.

### B. Multi-Task Focus UI & Priority Tie Resolution
- **Top 3 Hero & Supporting Cards**:
  - The #1 task retains the primary Focus Hero Card (large play button, prominent timer trigger, swipe gestures).
  - Tasks #2 and #3 are displayed in compact, high-legibility cards with quick actions (Start Timer, Quick Complete, Edit, Delete, Boost, Demote).
- **Tied Priority Handling**:
  - When the 3rd task shares the exact `priorityScore` (or within a tight tolerance \(\Delta < 0.01\)) with subsequent pending tasks (#4, #5...), an inline expandable section ("*+N tareas con igual prioridad*") smoothly reveals the tied tasks without requiring a screen switch.

### C. Notes / Description System
- `TaskEntity.description` is already present in Room database schema v3 as a `TEXT` column nullable.
- In `InboxModal`, a multi-line `OutlinedTextField` with expandable notes allows capturing detailed context without cluttering the single-line title.
- In `HomeScreen` and `TaskListScreen`, titles wrap cleanly with up to 3 lines or expandable text, while description notes can be collapsed/expanded via a gentle tap.

### D. Input Sanitization for Minutes / Numbers
- Jetpack Compose `OutlinedTextField` with `KeyboardOptions(keyboardType = KeyboardType.Number, imeAction = ImeAction.Done)` must also specify `singleLine = true` and `maxLines = 1`.
- State mutation `onValueChange` should sanitize inputs using `.filter { it.isDigit() }.take(4)` to prevent newline characters (`\n`) or non-numeric characters from invalidating `toIntOrNull()`.

### E. Task Demotion ("Anti-Boost")
- Symmetrical to `boostTask(taskId)`: `demoteTask(taskId)` decrements `manualBoost` by `manualBoostAmount`.
- `PriorityEngine.kt` computes `score = scoreBase + scoreDynamic + task.manualBoost`. Negative or lower `manualBoost` values naturally push the task down the priority queue.
- Both actions can be triggered via swipe gestures (or context action buttons) across `HomeScreen` and `TaskListScreen`.

### F. Optional Task Review & Completed Tasks History
- **Two User Modes**:
  1. *Zero-Friction Minimalist (`isHistoryTrackingEnabled = false`)*: Completes tasks immediately on timer finish with 0 modals or prompts. History views are hidden from the UI to maintain an uncluttered pending queue.
  2. *Reflective Mode (`isHistoryTrackingEnabled = true`)*: Prompts `QuickReviewModal` on timer finish to capture task completion outcome and emotional sentiment (`feelingEmoji`: 😢, 😐, 😄). A glassmorphic tab switch `[ Pendientes | Historial ]` in `TaskListScreen` displays completed tasks with their session duration, timestamp, uncomplete/restore actions, and bulk clear capability.
- **Room `@Relation` POJO**: `TaskWithSessions` pairs `TaskEntity` with `List<SessionEntity>` reactively in a single `@Transaction` query (`TaskDao.getCompletedTasksWithSessions()`), avoiding memory-stitched queries and ensuring data consistency.

---

## 3. Architecture & Security
- Zero remote backend / No cloud tracking: Backups remain strictly local and user-controlled.
- No hardcoded paths: SAF returns scoped content URIs managed by the Android OS.

