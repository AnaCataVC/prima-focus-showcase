# Implementation Notes

## Local-First Strategy
The core tenet of Prima-Focus is privacy and speed. 
- All modifications immediately persist to the Room Database (SQLite) on the Android device.
- There is no cloud synchronization or background syncing queue.
- No network connection is required to use the app.

## Recurrence
- Store rules in `RRULE` format in the `recurrence` field and generate local instances.
- Upon completing a recurring task, create the next instance based on the rule and save it to the local database.

## Migrations
- Strictly version the database schema.
- Provide migrations in Room using `Migration` classes to handle schema updates without data loss.

## UI Implementation
- The visual interface is natively built with **Jetpack Compose** following Material 3 guidelines and enforcing a Dark Mode aesthetic.
- The Pomodoro timer relies on an Android `Foreground Service` (`TimerService`) to ensure persistence and reliability even when the app is backgrounded.

## Background Processing & Notifications
- **WorkManager** is used for periodic background execution (`NotificationWorker`). The frequency is dynamically set based on user preferences in `SharedPreferences`.
- The background worker recalculates priority scores dynamically (since time urgency and age change) and triggers local notifications based on the top task's score.
- **Notification Thresholds:** Aggressive (Score >= 70), Standard (Score 40-69), Soft (Score < 40).

## Database & Domain Integration
- `TaskViewModel` acts as the bridge connecting the Compose UI with Room `TaskDao` and `SessionDao`. It manages dynamic UI states and reads/writes default creation preferences (`SharedPreferences`).
- **Null Timing (Infinity)**: If `estimatedMinutes` is set to `0` or left blank (falling back to a default of `0`), it is explicitly mapped to `null` before inserting into the database, allowing tasks to have infinite duration.
- Task priority is calculated deterministically through the `PriorityEngine` before every insertion and periodically by the background worker.

## Infrastructure & Clean Code
- **Dependency Management**: We use a central Version Catalog (`libs.versions.toml`) to declare all Gradle dependencies, keeping `build.gradle.kts` files clean and preventing version conflicts.
- **Constants & Utilities**: "Magic strings" (like SharedPreferences keys or Notification Channel IDs) are strictly avoided. They are centralized in `Constants.kt`. Shared mathematical or date/time logic is extracted to pure functions in `TimeUtils.kt`.
