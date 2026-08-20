# Implementation Notes

## Local-First Strategy & Synchronization
The core tenet of Prima-Focus is privacy and speed. 
- All modifications immediately persist to the Room Database (SQLite) on the Android device.
- There is no cloud synchronization or background syncing queue. No network connection is required to use the app.
- **Local P2P Sync**: Devices can sync their state offline using the Google Nearby Connections API. Synchronization happens dynamically when devices (e.g., Phone and Tablet) are in proximity.
- **Conflict Resolution**: Handled via a deterministic "Last-Write-Wins" strategy, utilizing the `updatedAt` timestamp to resolve divergent local states safely.

## Recurrence
- Store rules in `RRULE` format in the `recurrence` field and generate local instances.
- Upon completing a recurring task, create the next instance based on the rule and save it to the local database.

## Migrations
- Strictly version the database schema.
- Provide migrations in Room using `Migration` classes to handle schema updates without data loss.

## UI Implementation & Adaptive Layouts
- The visual interface is natively built with **Jetpack Compose** following Material 3 guidelines and enforcing a Dark Mode aesthetic.
- **Multi-Screen Support**: Utilizes `WindowSizeClass` to support adaptive scaling across form factors. Tablets (Expanded layout) feature a Split View interface with a custom Interactive Calendar that allows filtering tasks by date.
- The Pomodoro timer relies on an Android `Foreground Service` (`TimerService`) to ensure persistence and reliability even when the app is backgrounded.

## Background Processing & Notifications
- **WorkManager** is used for periodic background execution (`NotificationWorker`). The frequency is dynamically set based on user preferences in `SharedPreferences`.
- The background worker recalculates priority scores dynamically (since time urgency and age change) and triggers local notifications based on the top task's score.
- **Notification Thresholds:** Aggressive (Score >= 70), Standard (Score 40-69), Soft (Score < 40).

## Database & Domain Integration
- **Atomic Task Completion (No Timing)**: Tasks operate as discrete atomic items (Done / Pending) with no duration estimation or timing requirements. Tasks store `estimatedMinutes = null`, and the prioritization engine calculates scores using category weight, calendar day hierarchy, and age decay without duration bias.
- **Deterministic Multi-Column Ordering**: The SQL query enforces a strict 6-tier order (`priorityScore DESC`, `hasTime DESC`, `CASE WHEN date IS NULL THEN 1 ELSE 0 END`, `date ASC`, `createdAt ASC`, `taskId ASC`), ensuring predictable Top 3 selection and flicker-free tie-breaking.
- **Relational History Tracking**: Room POJO `TaskWithSessions` pairs completed tasks with their session sentiment and duration in a single `@Transaction` query. When `isHistoryTrackingEnabled` is disabled, timers complete tasks with zero modal friction and history views are hidden.
- **Storage Access Framework (SAF) Backup**: Serializes `TaskEntity` and `SessionEntity` collections into structured JSON, supporting non-destructive merges (via `updatedAt` LWW) and complete atomic overwrites.

## Infrastructure & Clean Code
- **Dependency Management**: We use a central Version Catalog (`libs.versions.toml`) to declare all Gradle dependencies, keeping `build.gradle.kts` files clean and preventing version conflicts.
- **Constants & Utilities**: "Magic strings" (like SharedPreferences keys or Notification Channel IDs) are strictly avoided. They are centralized in `Constants.kt`. Shared mathematical or date/time logic is extracted to pure functions in `TimeUtils.kt`.
