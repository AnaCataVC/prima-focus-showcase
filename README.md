<div align="center">
  <img src="assets/icon.png" width="120" alt="Prima-Focus Icon"/>
  <h1>Prima-Focus</h1>
</div>

<div align="center">
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20Desktop%20(PC)-3DDC84?style=flat&logo=android" alt="Platform Android & Desktop">
  <img src="https://img.shields.io/badge/Architecture-Local--First%20(KMP)-blue?style=flat" alt="Architecture Local-First">
  <img src="https://img.shields.io/badge/Room-v5%20%2B%20SQLite%20JDBC-4285F4?style=flat&logo=sqlite&logoColor=white" alt="Room v5 and SQLite JDBC">
  <img src="https://img.shields.io/badge/Kotlin-Multiplatform%202.2.10-0095D5?style=flat&logo=kotlin&logoColor=white" alt="Kotlin Multiplatform">
  <img src="https://img.shields.io/badge/Compose-Multiplatform%20Ready-4285F4?style=flat&logo=android&logoColor=white" alt="Compose Multiplatform">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License MIT">
</div>

<br>

> **Note**: This repository serves as a **Showcase**. The complete source code is kept private, but you can explore the technical documentation and try the app yourself!

<div align="center">
  <a href="#english">English</a> | <a href="#español">Español</a>
</div>

---

## English

### 📝 Project Description
**Prima-Focus** is a local-first task management and deep work application designed to help you focus on what truly matters. Built primarily as a **flagship native Android mobile application** (with an accompanying companion workstation client for **Desktop PC** via **Kotlin Multiplatform**), it uses an advanced predictive priority scoring system to dynamically select your "Today Task." All data is stored locally on each device for maximum privacy and performance, featuring hardened local LAN / P2P synchronization with cryptographic authentication without requiring any cloud backend.

### 🚀 Live Demo / Download
You can download the latest Android application directly from the [Releases](https://github.com/AnaCataVC/prima-focus-showcase/releases) tab:
👉 **[Download APK (Android)](https://github.com/AnaCataVC/prima-focus-showcase/releases/latest)**

### 🛠️ Technologies Used
- **Flagship Mobile Client**: Android Native, Jetpack Compose (Material Design 3), Jetpack Glance (App Widgets), Room Database v5, WorkManager & Foreground Services.
- **Companion Desktop Client & Core**: Kotlin Multiplatform (Kotlin 2.2.10), SQLite JDBC, Embedded HTTP Sync Server, HMAC-SHA256 & SHA-256 PIN Hashing.


### 🧠 Key Learnings
This project was a major engineering and architectural milestone. Throughout the process, I learned how to:
- Architect and build a modular **Kotlin Multiplatform (KMP)** system with decoupled shared domain logic.
- Implement independent local databases on mobile (**Room v5**) and desktop (**SQLite JDBC**).
- Design and red-team stress-test local network protocols with cryptographic authentication (HMAC/PIN).
- Handle clock-drift resilience, soft-delete tombstones, and garbage collection in distributed local-first systems.
- Master declarative UI design using **Jetpack Compose** and home screen widgets with **Jetpack Glance**.

### 📚 Documentation Index
Explore our comprehensive technical documentation to understand how Prima-Focus works under the hood:
- [System Architecture](docs/architecture.md)
- [Database Schema v5](docs/database_schema.sql)
- [Implementation Notes](docs/implementation_notes.md)
- [Priority Logic & Scoring](docs/priority-logic.md)
- [Desktop & LAN Sync Stress-Test](docs/external-references/desktop-kmp-sync-stress-test.md)
- [Notification Flow](docs/notification_flow.md)
- [UI Specifications](docs/ui_spec.md)
- [Learnings: P2P Sync, Tombstones & Clock Drift](docs/learning/p2p-sync-tombstones-clockdrift-gc.md)
- [External References & Widgets](docs/external-references/android-widgets.md)
- [All Architecture Learnings](docs/learning/)

---

## Español

### 📝 Descripción del Proyecto
**Prima-Focus** es una aplicación de gestión de tareas y enfoque profundo "local-first" diseñada para ayudarte a concentrarte en lo que realmente importa. Construida primordialmente como una **aplicación móvil nativa para Android** (complementada con un cliente de escritorio companion para **PC** mediante **Kotlin Multiplatform**), utiliza un avanzado sistema predictivo de puntuación de prioridad para seleccionar dinámicamente tu "Tarea de Hoy". Todos los datos se almacenan localmente en cada dispositivo para garantizar máxima privacidad y rendimiento, con sincronización local LAN / P2P blindada criptográficamente sin necesidad de servidores en la nube.

### 🚀 Descarga y Demo
Puedes descargar la última versión de la aplicación para Android directamente desde la pestaña de [Releases](https://github.com/AnaCataVC/prima-focus-showcase/releases):
👉 **[Descargar APK (Android)](https://github.com/AnaCataVC/prima-focus-showcase/releases/latest)**

### 🛠️ Tecnologías Utilizadas
- **Aplicación Móvil Principal**: Android Nativo, Jetpack Compose (Material Design 3), Jetpack Glance (App Widgets), Room Database v5, WorkManager y Foreground Services.
- **Cliente Companion de Escritorio y Núcleo**: Kotlin Multiplatform (Kotlin 2.2.10), SQLite JDBC, Servidor HTTP Embebido, HMAC-SHA256 y Hash SHA-256 para PIN.


### 🧠 Aprendizajes Clave
Este proyecto representó un gran hito de ingeniería y arquitectura. A lo largo del proceso aprendí a:
- Diseñar y construir una arquitectura modular en **Kotlin Multiplatform (KMP)** con capa de dominio desacoplada.
- Implementar bases de datos locales independientes en móvil (**Room v5**) y escritorio (**SQLite JDBC**).
- Diseñar y someter a auditoría *Red Team* protocolos de red local protegidos con firmas criptográficas (HMAC/PIN).
- Resolver desafíos de *Clock Drift*, lápidas tombstones y recolección de basura en sistemas distribuidos *local-first*.
- Dominar el diseño de interfaces declarativas con **Jetpack Compose** y widgets con **Jetpack Glance**.

### 📚 Índice de Documentación Técnica
Explora nuestra documentación técnica completa para entender cómo funciona Prima-Focus internamente:
- [Arquitectura del Sistema](docs/architecture.md)
- [Esquema de Base de Datos v5](docs/database_schema.sql)
- [Notas de Implementación](docs/implementation_notes.md)
- [Lógica de Prioridades](docs/priority-logic.md)
- [Stress-Test Desktop y Sync LAN](docs/external-references/desktop-kmp-sync-stress-test.md)
- [Flujo de Notificaciones](docs/notification_flow.md)
- [Especificaciones de UI](docs/ui_spec.md)
- [Lecciones: P2P Sync, Tombstones y Clock Drift](docs/learning/p2p-sync-tombstones-clockdrift-gc.md)
- [Referencias Externas y Widgets](docs/external-references/android-widgets.md)
- [Todos los Aprendizajes y Decisiones](docs/learning/)

