# Prima-Focus Architecture

## Overview
Prima-Focus is a local-first task management application built natively for Android. 
It is designed to provide a robust, private, and highly responsive experience by keeping all data on the device.

## Core Stack
- **Language**: Kotlin
- **UI Toolkit**: Jetpack Compose
- **Local Persistence**: Room Database (SQLite)
- **Background Processing & Scheduling**: `WorkManager` paired with Foreground Services for resilient timers and notifications.

## Components
- **Data Layer**: Local DB schemas (Room entities), DAOs, and Repositories.
- **Domain Layer**: Business rules, primarily the predictive `priorityScore` calculation (`TaskEngine`).
- **UI Layer**: Presentation logic built with a minimalist technical pastel design system using Jetpack Compose (e.g., `HomeScreen`, `TimerScreen`).
- **Notification Layer**: A dynamic scheduler using Android's `WorkManager` that assesses the priority score to trigger aggressive, standard, or soft reminders locally.
- **Utils Layer**: Centralized helpers and constants (e.g., `TimeUtils`, `Constants`) to enforce the DRY (Don't Repeat Yourself) principle and avoid magic strings across the app.

## System Architecture Diagram

```text
+----------------------+        +----------------------+
|  Android Client      | <----> |  Local Persistence   |
|  (Kotlin/Compose)    |        |  (Room Database)     |
|                      |        |                      |
|  - UI (Inbox, Hoy)   |        |  - Tasks Table       |
|  - Domain rules      |        |  - Sessions Table    |
|  - ViewModels        |        |  - Events Table      |
|  - WorkManager / FS  |        |                      |
+----------------------+        +----------------------+
         |  ^
         |  |
         v  |
+----------------------+
| Notification Manager |
| (Local Push Alerts)  |
+----------------------+
```

### Implementation Notes:
- **Offline-First**: Because there is no backend, all operations are instantly committed to Room.
- **Notifications**: Scheduled locally via `WorkManager` or `AlarmManager` without relying on Firebase Cloud Messaging (FCM).
