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
- **Data Layer**: Local DB schemas (Room entities), DAOs, and Repositories. Conflict resolution uses Last-Write-Wins based on `updatedAt`.
- **Domain Layer**: Business rules, primarily the predictive `priorityScore` calculation (`TaskEngine`).
- **UI Layer**: Presentation logic built with a minimalist technical pastel design system using Jetpack Compose (e.g., `HomeScreen`, `TimerScreen`). Supports multiple form factors, including a Tablet-optimized Split View with an Interactive Calendar to filter tasks by date.
- **Notification Layer**: A dynamic scheduler using Android's `WorkManager` that assesses the priority score to trigger aggressive, standard, or soft reminders locally.
- **Utils Layer**: Centralized helpers and constants (e.g., `TimeUtils`, `Constants`) to enforce the DRY (Don't Repeat Yourself) principle and avoid magic strings across the app.

## System Architecture Diagram

```text
+----------------------+        +----------------------+
|  Android Client      | <----> |  Local Persistence   |
|  (Kotlin/Compose)    |        |  (Room Database)     |
|                      |        |                      |
|  - UI (Phone/Tablet) |        |  - Tasks Table       |
|  - Split View & Cal. |        |  - Sessions Table    |
|  - Domain rules      |        |  - Events Table      |
|  - ViewModels        |        |                      |
|  - WorkManager / FS  |        |                      |
+----------------------+        +----------------------+
         |  ^   ^                         ^
         |  |   |                         |
         v  |   v (P2P Sync)              v
+----------------------+        +----------------------+
| Notification Manager |        | Nearby Connections   |
| (Local Push Alerts)  |        | API (Local P2P Sync) |
+----------------------+        +----------------------+
```

### Implementation Notes:
- **Offline-First**: Because there is no backend, all operations are instantly committed to Room.
- **Multi-Device Local Sync**: Devices synchronize via P2P (Google Nearby Connections) when in proximity. Conflicts are resolved automatically using a "Last-Write-Wins" policy based on the `updatedAt` timestamp.
- **Adaptive Layouts**: `WindowSizeClass` dynamically switches between Compact and Expanded layouts to provide optimal UX on both phones and tablets.
- **Notifications**: Scheduled locally via `WorkManager` or `AlarmManager` without relying on Firebase Cloud Messaging (FCM).
