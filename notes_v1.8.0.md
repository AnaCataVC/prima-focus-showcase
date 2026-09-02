# Prima-Focus v1.8.0 — LAN Sync Companion & Cross-Platform Productivity

## English

### What's New & Key Highlights
* **LAN Sync Companion Feature:** Secure local area network synchronization between mobile (Android) and desktop workstations (PC). Connect seamlessly over local Wi-Fi without third-party cloud infrastructure.
* **Mutual PIN Authentication & HMAC Signatures:** Pairing secured with 6-digit PIN hashing (SHA-256) and per-request payload signatures (HMAC-SHA256) with brute-force rate-limiting and automatic lockout.
* **Room Database v6 Relational Engine:** Streamlined data layer with `MIGRATION_5_6`, dropping obsolete tables (`events`) to optimize performance for active tasks and sessions.
* **Clock-Drift Resilient LWW Merge:** Enhanced conflict resolution using monotonic `syncVersion` and `updatedAt` timestamps, preventing clock skew and out-of-order writes from dropping offline edits.
* **Soft Delete Tombstones & Auto-Purge:** Comprehensive tombstone tracking (`isDeleted = 1`) with automatic 30-day garbage collection at startup to prevent zombie task resurrection.
* **Non-Regressive Task Completion:** Tasks marked as completed remain completed across synchronization cycles regardless of minor timestamp drift.
* **Jetpack Glance Home Screen Widgets:** Interactive quick-add and top task widgets with direct completion toggle and category filtering.
* **Adaptive Tablet Split-View:** Dynamic layouts responding to `WindowSizeClass` with calendar-based task scheduling.

### Download APK
Download the signed APK file below (`prima-focus-v1.8.0.apk`) and install it directly on any Android device running Android 8.0 or higher (`minSdk 26`).

---

## Español

### Novedades y Características Principales
* **Sincronización LAN con Cliente Companion:** Sincronización segura en red de área local entre dispositivos móviles (Android) y estaciones de trabajo de escritorio (PC). Conexión directa vía Wi-Fi local sin depender de servidores ni nube externa.
* **Autenticación Mutua por PIN y Firmas HMAC:** Emparejamiento protegido con hash de PIN de 6 dígitos (SHA-256) y firmas criptográficas por mensaje (HMAC-SHA256), con protección contra ataques de fuerza bruta y bloqueo temporal automático.
* **Motor Relacional Room Database v6:** Capa de datos optimizada con `MIGRATION_5_6`, eliminando tablas en desuso (`events`) para maximizar el rendimiento en tasks y sessions.
* **Resolución LWW Inmune al Clock Drift:** Motor de sincronización determinista Last-Write-Wins guiado por `syncVersion` y marcas de tiempo `updatedAt`, tolerando diferencias horarias entre dispositivos.
* **Lápidas de Borrado (Tombstones) y Purga Automática:** Seguimiento de borrados lógicos (`isDeleted = 1`) con recolección de basura automática a los 30 días para evitar la reaparición de tareas eliminadas.
* **No-Regresión en Tareas Completadas:** Las tareas marcadas como finalizadas se mantienen completadas tras sincronizar, independientemente de desfases en el reloj local.
* **Widgets Enriquecidos con Jetpack Glance:** Widgets interactivos para pantalla de inicio con marcado rápido de tareas y accesos directos por categoría.
* **Diseño Adaptativo Split-View para Tablets:** Interfaz optimizada para pantallas grandes y tablets con panel de calendario para programación visual de tareas.

### Descarga del APK
Descarga el archivo APK firmado adjunto (`prima-focus-v1.8.0.apk`) e instálalo directamente en cualquier dispositivo con Android 8.0 o superior (`minSdk 26`).
