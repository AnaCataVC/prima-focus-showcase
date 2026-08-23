# Implementation Notes

## Local-First Strategy & Synchronization
The core tenet of Prima-Focus is privacy and speed. 
- All modifications immediately persist to the Room Database (SQLite) on the Android device.
- There is no cloud synchronization or remote server dependency. No network connection is required to use the app.
- **Local P2P Sync**: Devices sync their state offline using the Google Nearby Connections API (`P2P_STAR` topology).
- **Clock-Drift Resilient LWW**: Conflict resolution compares `syncVersion` first, falling back to `updatedAt` only when versions match. This prevents local clock skew from corrupting newer edits.
- **Soft Deletes (Tombstones)**: Deletions flag `isDeleted = 1` with a `deletedAt` timestamp and incremented `syncVersion`, preventing deleted tasks from resurrecting when synced against offline peers.
- **30-Day Tombstone Purge**: The database executes an automatic garbage collection query on application start (`TaskViewModel`), physically deleting tombstones older than 30 days to keep SQLite performant.
- **P2P Safety Protections**:
  - `AUTO_TIMEOUT_MS = 45000L`: Discovery and Advertising automatically abort after 45 seconds of inactivity to protect battery life.
  - `MAX_PAYLOAD_BYTES = 5MB`: Payloads exceeding 5 MB are rejected immediately to prevent heap exhaustion.
  - `Build.MODEL`: Human-readable device names (capped at 25 chars) are advertised for frictionless peer recognition.

## Migrations (v1 -> v5)
- Strictly version the database schema.
- Provide migrations in Room using `Migration` classes to handle schema updates without data loss:
  - `MIGRATION_1_2`: Added `recurrenceGroupId` to tasks.
  - `MIGRATION_2_3`: Removed deprecated `subtasksCount` column via table recreate.
  - `MIGRATION_3_4`: Removed `durationMinutes` from sessions table.
  - `MIGRATION_4_5`: Added `isDeleted`, `deletedAt`, and `syncVersion` to both `tasks` and `sessions` tables.

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
