# Prima-Focus Architecture

## Overview
Prima-Focus is a local-first task management application built with a **modular Kotlin Multiplatform (KMP)** architecture for Android and Desktop (PC). 
It is designed to provide a robust, private, and highly responsive experience by keeping all data locally on each device. It supports multiple form factors (phones, tablets, and desktop workstations) and synchronizes seamlessly across devices using secure local peer-to-peer (P2P) networking and local area network (LAN) protocols without requiring any cloud backend.

## Core Stack
- **Language**: Kotlin Multiplatform (Kotlin 2.2.10)
- **UI Toolkits**: Jetpack Compose (Material Design 3 with Adaptive Layouts) for Android, Compose / Swing for Desktop.
- **Local Persistence**: Room Database v6 (Android) & SQLite JDBC with deterministic schemas (Desktop).
- **Background Processing & Scheduling**: Android `WorkManager` & Foreground Services for mobile timers/notifications.
- **P2P & LAN Networking/Sync**: Google Nearby Connections API (Android-to-Android) and Secure Local LAN Sync with HMAC-SHA256 & 6-Digit PIN pairing (Mobile-to-Desktop).

## Module Structure
- **`:shared` (`com.ancata.prima_focus.core`)**: Common domain logic, `SharedPriorityEngine`, data models (`Task`, `Session`, `PriorityBand`), recurrence calculations (`SharedRecurrenceCalculator`), quiet hours scheduling (`SharedTimeUtils`), and the version-aware Last-Write-Wins (LWW) conflict resolution engine (`SyncMergeEngine`).
- **`:app` (`com.ancata.prima_focus`)**: Native Android client featuring Room v6 persistence, Material 3 Glassmorphism UI, Jetpack Glance Home Screen Widgets, and WorkManager background reminders.
- **`:desktop` (`com.ancata.prima_focus.desktop`)**: Native Desktop client featuring independent local SQLite storage, HTTP/JSON LAN sync server with cryptographic verification, keyboard productivity shortcuts (`Ctrl+N`, `Ctrl+Enter`), and offline JSON backup fallback.

## System Architecture Diagram

```text
+-------------------------------------------------------------------------+
|                    :shared (Core Domain Module)                         |
|                                                                         |
|  - SharedPriorityEngine (Base Score + Time Urgency + Aging)             |
|  - Models: Task, Session, PriorityBand, LANSyncPacket                   |
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
|  - Room Database v6 (Tombstones)  |   |  - Local SQLite DB (AppData WAL)  |
|  - Nearby P2P (Host / Client)     |   |  - DesktopSyncServer (Port 8765)  |
|  - WorkManager Reminders & Glance |   |  - JSON Backup Export/Import      |
+-----------------------------------+   +-----------------------------------+
                  \                                       /
                   \--- [ Secure Local LAN Wi-Fi Sync ] -/
                        - 6-Digit PIN Authentication
                        - HMAC-SHA256 Payload Signature
                        - Atomic LWW Delta Merge
```

## Synchronization & Mode Selection Architecture

### 1. Mobile-to-Desktop LAN Sync
- **Desktop Host (`DesktopSyncServer`)**: Runs an embedded lightweight HTTP server bound to port 8765 (with automatic fallback to consecutive ports if occupied) on a bounded 4-worker thread pool. Generates a random 6-digit session PIN and displays the machine's primary local IPv4 address (filtering virtual adapters like Docker/WSL).
- **Android Client (`LanSyncClient`)**: Initiates a 2-step authenticated handshake:
  1. `/api/pair`: Transmits device ID, device name, and `SHA-256(PIN)`. The server verifies the hash, generates a secure one-time session token, and returns it. Rate limiting triggers a 30-second lockout and regenerates the PIN after 5 consecutive incorrect attempts.
  2. `/api/sync`: Dispatches local changes inside a `LANSyncPacket` signed with `HMAC-SHA256` in the `X-Auth-Signature` header. The server validates the signature, merges incoming deltas, and returns its local dataset signed with the same key for symmetric verification.
- **Network Isolation Fallback**: When connected to restricted guest or enterprise Wi-Fi networks enforcing *AP Client Isolation*, users can export and import complete JSON backups with atomic Last-Write-Wins merging.

### 2. Mobile-to-Mobile Nearby P2P Sync (Host vs Client Selection)
- Employs Google Nearby Connections using the `P2P_STAR` topology.
- In `SettingsScreen`, users explicitly choose their synchronization role:
  - **Host ("Ser Anfitrión")**: Executes `p2pSyncManager.startAdvertising()`, broadcasting the device model to nearby peers.
  - **Client ("Ser Cliente")**: Executes `p2pSyncManager.startDiscovery()`, scanning for available advertising peers.
- **Battery & Safety Protections**:
  - Discovery and Advertising automatically abort after 45 seconds of inactivity (`AUTO_TIMEOUT_MS = 45000L`).
  - Payloads exceeding 5 MB (`MAX_PAYLOAD_BYTES`) are rejected immediately.

### 3. Room Database v6 Schema & Data Guarantees
- **Removal of Legacy Tables**: Room v6 (`MIGRATION_5_6`) drops the unused dead table `events`, leaving a streamlined relational schema comprised solely of `tasks` and `sessions`.
- **Clock-Drift Immunity**: Two-tier conflict resolution checks `syncVersion` before `updatedAt`, ensuring offline edits on out-of-sync clocks are never discarded.
- **Non-Regressive Completed State**: Completed tasks remain completed during sync merges even if an older pending state has a slightly drifted timestamp.
- **Automatic 30-Day Tombstone Purge**: Hard deletions are converted to soft-deletions (`isDeleted = 1`), and entries older than 30 days are purged automatically at application startup to keep SQLite storage fast and compact.
