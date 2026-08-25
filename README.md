<div align="center">
  <img src="assets/icon.png" width="120" alt="Prima-Focus Icon"/>
  <h1>Prima-Focus</h1>
</div>

<div align="center">
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?style=flat&logo=android" alt="Platform Android">
  <img src="https://img.shields.io/badge/Architecture-Local--First-blue?style=flat" alt="Architecture Local-First">
  <img src="https://img.shields.io/badge/Room-v5%20(Tombstones%20%2B%20LWW)-4285F4?style=flat&logo=sqlite&logoColor=white" alt="Room v5">
  <img src="https://img.shields.io/badge/Kotlin-0095D5?style=flat&logo=kotlin&logoColor=white" alt="Kotlin">
  <img src="https://img.shields.io/badge/Jetpack_Compose-4285F4?style=flat&logo=android&logoColor=white" alt="Jetpack Compose">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License MIT">
</div>

<br>

> **Note**: This repository serves as a **Showcase**. The complete source code is kept private, but you can explore the technical documentation and download the APK to try the app yourself!

<div align="center">
  <a href="#english">English</a> | <a href="#español">Español</a>
</div>

---

## English

### 📝 Project Description
**Prima-Focus** is a local-first task management application designed to help you focus on what truly matters. Built natively for Android, it uses an advanced predictive priority scoring system to dynamically select your "Today Task." All data is stored locally on the device for maximum privacy and performance, featuring hardened Peer-to-Peer (P2P) synchronization across devices without requiring any cloud backend.

### 🚀 Live Demo / Download
You can download the latest version of the app directly from the [Releases](https://github.com/AnaCataVC/prima-focus-showcase/releases) tab:
👉 **[Download APK (v1.7.1)](https://github.com/AnaCataVC/prima-focus-showcase/releases/latest)**

### 🛠️ Technologies Used
- **Language**: Kotlin
- **UI Toolkit**: Jetpack Compose (Material Design 3) & Jetpack Glance (App Widgets)
- **Local Persistence**: Room Database v5 (SQLite)
- **P2P Synchronization**: Google Nearby Connections API
- **Background Processing**: WorkManager & Foreground Services

### 🧠 Key Learnings
This project was a major milestone as it was **my very first time developing a native mobile application**. Throughout the process, I learned how to:
- Architect and build a complete mobile app from scratch.
- Master declarative UI design using **Jetpack Compose** and home screen widgets with **Jetpack Glance**.
- Implement local database persistence and migrations using **Room**.
- Handle complex background tasks and asynchronous notifications using **WorkManager** and **Foreground Services**.
- Design robust offline P2P data synchronization algorithms and conflict resolution strategies.

### 📚 Documentation Index
Explore our comprehensive technical documentation to understand how Prima-Focus works under the hood:
- [System Architecture](docs/architecture.md)
- [Database Schema v5](docs/database_schema.sql)
- [Implementation Notes](docs/implementation_notes.md)
- [Priority Logic & Scoring](docs/priority-logic.md)
- [Notification Flow](docs/notification_flow.md)
- [UI Specifications](docs/ui_spec.md)
- [Learnings: P2P Sync, Tombstones & Clock Drift](docs/learning/p2p-sync-tombstones-clockdrift-gc.md)
- [External References & Widgets](docs/external-references/android-widgets.md)
- [All Architecture Learnings](docs/learning/)

---

## Español

### 📝 Descripción del Proyecto
**Prima-Focus** es una aplicación de gestión de tareas "local-first" diseñada para ayudarte a enfocarte en lo que realmente importa. Construida nativamente para Android, utiliza un avanzado sistema predictivo de puntuación de prioridad para seleccionar dinámicamente tu "Tarea de Hoy". Todos los datos se almacenan localmente en el dispositivo para garantizar máxima privacidad y rendimiento, con sincronización local P2P blindada sin necesidad de servidores en la nube.

### 🚀 Descarga y Demo
Puedes descargar la última versión de la aplicación directamente desde la pestaña de [Releases](https://github.com/AnaCataVC/prima-focus-showcase/releases):
👉 **[Descargar APK (v1.7.1)](https://github.com/AnaCataVC/prima-focus-showcase/releases/latest)**

### 🛠️ Tecnologías Utilizadas
- **Lenguaje**: Kotlin
- **Interfaz Gráfica**: Jetpack Compose (Material Design 3) y Jetpack Glance (App Widgets)
- **Persistencia Local**: Base de datos Room v5 (SQLite)
- **Sincronización P2P**: Google Nearby Connections API
- **Procesamiento en Segundo Plano**: WorkManager y Foreground Services

### 🧠 Aprendizajes Clave
Este proyecto representó un gran hito personal, ya que fue **la primera vez que desarrollé una aplicación móvil nativa**. A lo largo del proceso aprendí a:
- Diseñar y construir la arquitectura de una app móvil desde cero.
- Dominar el diseño de interfaces declarativas utilizando **Jetpack Compose** y widgets de pantalla de inicio con **Jetpack Glance**.
- Implementar almacenamiento local y migraciones con **Room**.
- Manejar tareas complejas en segundo plano y notificaciones asíncronas utilizando **WorkManager** y **Foreground Services**.
- Diseñar algoritmos de sincronización de datos P2P offline y resolución de conflictos.

### 📚 Índice de Documentación Técnica
Explora nuestra documentación técnica completa para entender cómo funciona Prima-Focus internamente:
- [Arquitectura del Sistema](docs/architecture.md)
- [Esquema de Base de Datos v5](docs/database_schema.sql)
- [Notas de Implementación](docs/implementation_notes.md)
- [Lógica de Prioridades](docs/priority-logic.md)
- [Flujo de Notificaciones](docs/notification_flow.md)
- [Especificaciones de UI](docs/ui_spec.md)
- [Lecciones: P2P Sync, Tombstones y Clock Drift](docs/learning/p2p-sync-tombstones-clockdrift-gc.md)
- [Referencias Externas y Widgets](docs/external-references/android-widgets.md)
- [Todos los Aprendizajes y Decisiones](docs/learning/)
