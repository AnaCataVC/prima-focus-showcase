# Prima-Focus v1.7.2 🚀 Desktop Companion & Secure Local LAN Sync

## English

### 🌟 What's New & Key Highlights
* **Kotlin Multiplatform (KMP) Architecture:** Full migration to a modular architecture with a shared domain core (`:shared`), Android native mobile client (`:app`), and PC workstation client (`:desktop`).
* **Secure Local LAN Synchronization:** High-speed, encrypted peer-to-peer sync between Android mobile/tablet and Desktop PC over local Wi-Fi, authenticated via 6-digit PIN pairing and per-request HMAC-SHA256 cryptographic signatures.
* **Desktop Companion Workstation (PC):** Native desktop client featuring local SQLite storage, rapid productivity hotkeys (`Ctrl+N`, `Enter`), embedded HTTP sync server (Port 8765), and complete offline autonomy.
* **Tombstones & Clock-Drift Resilient Sync:** Version-aware *Last-Write-Wins* conflict resolution engine combining `syncVersion` and `updatedAt`, with soft deletes and automatic 30-day garbage collection.
* **Rich Android Widgets (Jetpack Glance):** Interactive home screen widgets including `TopThreeTasksWidget` with instant completion checkboxes and `QuickAddWidget` with direct category chips (Work, Health, Home).
* **Adaptive Tablet Dashboard:** Responsive split-view layout (`WindowSizeClass`) with an interactive calendar panel for scheduling and filtering tasks.
* **Local-First Room Database v5:** Resilient schema migrations, non-regressive task states, and paired relational session history.

### 📦 Download APK
Download the signed APK file below and install it directly on any Android device running Android 8.0+ (`minSdk 26`).

---

## Español

### 🌟 Novedades y Características Principales
* **Arquitectura Kotlin Multiplatform (KMP):** Migración completa a una arquitectura modular con núcleo de dominio compartido (`:shared`), cliente móvil nativo Android (`:app`) y cliente de escritorio PC (`:desktop`).
* **Sincronización Segura en Red Local (LAN):** Sincronización P2P de alta velocidad entre Android y PC vía Wi-Fi local, protegida con emparejamiento por PIN de 6 dígitos y firmas criptográficas HMAC-SHA256 por petición.
* **Cliente Companion para Escritorio (PC):** Aplicación de escritorio con base de datos SQLite local independiente, atajos de teclado rápidos (`Ctrl+N`, `Enter`), servidor embebido de sincronización (Puerto 8765) y funcionamiento 100% offline.
* **Lápidas (Tombstones) e Inmunidad a Desfase de Reloj:** Motor de resolución de conflictos *Last-Write-Wins* consciente de versiones (`syncVersion` + `updatedAt`), con borrado suave (*soft-delete*) y purga automática (*Garbage Collection*) de 30 días.
* **Widgets Enriquecidos para Android (Jetpack Glance):** Widgets interactivos para la pantalla de inicio, incluyendo `TopThreeTasksWidget` con botón de completado directo y `QuickAddWidget` con accesos directos por categoría.
* **Dashboard Adaptativo para Tablets:** Interfaz optimizada en pantalla dividida (*Split-View*) con panel de calendario interactivo para planificar tareas por fecha.
* **Base de Datos Room v5 Local-First:** Migraciones de esquema deterministas, estados de tareas no regresivos e historial relacional de enfoque.

### 📦 Descarga del APK
Descarga el archivo APK firmado adjunto en este release e instálalo directamente en cualquier dispositivo con Android 8.0 o superior (`minSdk 26`).
