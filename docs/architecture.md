# Prima-Focus Architecture

## Overview
Prima-Focus is a local-first task management application built natively for Android. 
It is designed to provide a robust, private, and highly responsive experience by keeping all data on the device. It now supports multiple screen sizes (phones and tablets) and synchronizes seamlessly across devices using local P2P networking without a cloud backend.

## Core Stack
- **Language**: Kotlin
- **UI Toolkit**: Jetpack Compose (Adaptive layouts via WindowSizeClass)
- **Local Persistence**: Room Database (SQLite)
- **Background Processing & Scheduling**: `WorkManager` paired with Foreground Services for resilient timers and notifications.
- **Networking/Sync**: Google Nearby Connections API for local P2P synchronization.

## Components
- **Data Layer**: Local DB schemas (Room entities), DAOs, relational queries (`TaskWithSessions`), and Repositories. Conflict resolution uses Last-Write-Wins based on `updatedAt`. Includes atomic transactions for batch imports, recurrence generation, and history management.
- **Domain Layer**: Business rules, primarily the predictive `priorityScore` calculation (`PriorityEngine`) supporting dynamic time urgency, aging, non-postponable rules, manual boost, and demotion (anti-boost).
- **UI Layer**: Presentation logic built with a minimalist technical pastel design system using Jetpack Compose (e.g., `HomeScreen`, `TaskListScreen`, `TimerScreen`, `SettingsScreen`). Supports multiple form factors, Top 3 focus cards + tie clustering, optional completed task history, and a Tablet-optimized Split View with an Interactive Calendar.
- **Notification Layer**: A dynamic scheduler using Android's `WorkManager` that assesses the priority score to trigger aggressive, standard, or soft reminders locally.
- **Utils Layer**: Centralized helpers and constants (e.g., `TimeUtils`, `Constants`, `RecurrenceCalculator`) to enforce the DRY (Don't Repeat Yourself) principle and avoid magic strings across the app.

## System Architecture Diagram

```text
+----------------------+        +----------------------+
|  Android Client      | <----> |  Local Persistence   |
|  (Kotlin/Compose)    |        |  (Room Database)     |
|                      |        |                      |
|  - UI (Phone/Tablet) |        |  - Tasks Table       |
|  - Split View & Cal. |        |  - Sessions Table    |
|  - Top 3 + Ties      |        |  - TaskWithSessions  |
|  - Optional History  |        |  - SAF Backup/Restore|
|  - Domain rules      |        +----------------------+
|  - ViewModels        |                  ^
|  - WorkManager / FS  |                  |
+----------------------+                  |
         |  ^   ^                         |
         |  |   |                         |
         v  |   v (P2P Sync)              v
+----------------------+        +----------------------+
| Notification Manager |        | Nearby Connections   |
| (Local Push Alerts)  |        | API (Local P2P Sync) |
+----------------------+        +----------------------+
```

### Implementation Notes:
- **Offline-First**: Because there is no backend, all operations are instantly committed to Room.
- **Storage Access Framework (SAF)**: Native Android file picker integration allows exporting and importing complete encrypted/unencrypted JSON backups with merge and overwrite strategies.
- **Multi-Device Local Sync**: Devices synchronize via P2P (Google Nearby Connections) when in proximity. Conflicts are resolved automatically using a "Last-Write-Wins" policy based on the `updatedAt` timestamp.
- **Adaptive Layouts**: `WindowSizeClass` dynamically switches between Compact and Expanded layouts to provide optimal UX on both phones and tablets.
- **Notifications**: Scheduled locally via `WorkManager` or `AlarmManager` without relying on Firebase Cloud Messaging (FCM).
- **Optional Task Review & History**: User-toggleable feedback collection upon timer finish with reactive Room `@Relation` history views.
