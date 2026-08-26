# Prima-Focus Architecture

## Overview
Prima-Focus is a local-first task management application built with a **modular Kotlin Multiplatform (KMP)** architecture for Android and Desktop (PC). 
It is designed to provide a robust, private, and highly responsive experience by keeping all data locally on each device. It supports multiple form factors (phones, tablets, and desktop workstations) and synchronizes seamlessly across devices using secure local peer-to-peer (P2P) networking without requiring a cloud backend.

## Core Stack
- **Language**: Kotlin Multiplatform (Kotlin 2.2.10)
- **UI Toolkits**: Jetpack Compose (Material Design 3 with Adaptive Layouts) for Android, Compose / Swing for Desktop.
- **Local Persistence**: Room Database v5 (Android) & SQLite JDBC with deterministic schemas (Desktop).
- **Background Processing & Scheduling**: Android `WorkManager` & Foreground Services for mobile timers/notifications.
- **P2P & LAN Networking/Sync**: Google Nearby Connections API (Android-to-Android) and Secure Local LAN Sync with HMAC-SHA256 & 6-Digit PIN pairing (Mobile-to-Desktop).

## Module Structure
- **`:shared` (`com.ancata.prima_focus.core`)**: Common domain logic, `SharedPriorityEngine`, data models (`Task`, `Session`), recurrence calculations (`SharedRecurrenceCalculator`), quiet hours scheduling (`SharedTimeUtils`), and the version-aware Last-Write-Wins (LWW) conflict resolution engine (`SyncMergeEngine`).
- **`:app` (`com.ancata.prima_focus`)**: Native Android client featuring Room v5 persistence, Material 3 Glassmorphism UI, Jetpack Glance Home Screen Widgets, and WorkManager background reminders.
- **`:desktop` (`com.ancata.prima_focus.desktop`)**: Native Desktop client featuring independent local SQLite storage, HTTP/JSON LAN sync server with cryptographic verification, keyboard productivity shortcuts (`Ctrl+N`, `Ctrl+Enter`), and offline JSON backup fallback.

## System Architecture Diagram

```text
+-------------------------------------------------------------------------+
|                    :shared (Core Domain Module)                        |
|                                                                         |
|  - SharedPriorityEngine (Base Score + Time Urgency + Aging)             |
|  - Models: Task, Session, SyncDataPayload                               |
|  - SyncMergeEngine (LWW + Clock-Drift Immunity + Non-Regressive State)  |
|  - LANAuthSecurity (6-Digit PIN Hash + HMAC-SHA256 Signatures)          |
|  - SharedRecurrenceCalculator & SharedTimeUtils                         |
+-------------------------------------------------------------------------+
                    ^                                   ^
                    |                                   |
+-----------------------------------+   +-----------------------------------+
|     :app (Android Native Client)  |   |    :desktop (Desktop Client - PC) |
|                                   |   |                                   |
|  - Compose UI (Phone/Tablet)      |   |  - Desktop Window & List View     |
|  - Split View & Calendar Widget   |   |  - Fast Hotkeys (Ctrl+N, Enter)   |
|  - Room Database v5 (Tombstones)  |   |  - Local SQLite DB (AppData)      |
|  - Nearby Connections (Mobile P2P)|   |  - DesktopSyncServer (Port 8765)  |
|  - WorkManager Reminders & Glance |   |  - JSON Backup Export/Import      |
+-----------------------------------+   +-----------------------------------+
                  \                                       /
                   \--- [ Secure Local LAN Wi-Fi Sync ] -/
                        - 6-Digit PIN Authentication
                        - HMAC-SHA256 Payload Signature
                        - Atomic LWW Delta Merge
```

### Implementation Notes:
- **Offline-First & Data Independence**: Each device maintains its own complete database. The PC version works 100% offline without needing the phone to be turned on or connected.
- **Clock-Drift Immunity**: Synchronization uses a 2-tier Last-Write-Wins hierarchy (`syncVersion` -> `updatedAt`), preventing time skew from discarding valid edits.
- **Non-Regressive Completed State**: Completed tasks remain completed during sync merges even if an older pending state has a slightly drifted timestamp.
- **LAN Security & Privacy**: LAN communication is protected against unauthorized local network injection via PIN pairing and per-request HMAC verification.
- **Network Isolation Fallback**: In environments with *AP Client Isolation* (office/university Wi-Fi), users can export and import complete JSON backups with atomic merge.

