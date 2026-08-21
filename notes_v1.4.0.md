# Prima-Focus v1.4.0 📱✨

¡Nueva versión con mejoras completas para los **App Widgets** de Android!

---

## 🚀 Novedades y Características

### 1. Nuevo Widget Top 3 Tareas (`TopThreeTasksWidget`)
- Desarrollado con **Jetpack Glance 1.1.1** (Compose declarativo para widgets).
- Muestra las **3 tareas más urgentes** calculadas automáticamente por el algoritmo predictivo de prioridades.
- Badges cromáticos de prioridad: 🔴 Alta (score ≥ 70), 🟠 Media (score ≥ 40), 🟢 Normal.
- Botón **`✓` individual** en cada tarea para marcarla como completada directamente en segundo plano sin abrir la app.
- Atajo para abrir la app al tocar la tarea o el badge de abrir.

### 2. Completar Tarea desde el Widget de 1 Tarea
- Se agregó el botón de checkmark directo en el widget clásico de 1 tarea.
- Completa la tarea de forma atómica y refresca todos los widgets instalados.

### 3. Widget Enriquecido de Creación Rápida (`QuickAddWidget`)
- Nuevo widget con atajos directos por categoría:
  - 💼 **Trabajo**
  - 🏥 **Salud**
  - 🏠 **Casa**
  - ➕ **Creación general**
- Al pulsar un chip, abre la app con el modal de creación y la categoría correspondiente preseleccionada.

### 4. Capa de Dominio Robusta (`TaskCompletionUseCase`)
- Lógica de completado extraída a un caso de uso independiente.
- Gestión segura de **tareas recurrentes** (diarias, semanales, mensuales).
- Registro automático en el historial de sesiones sin abrir la app.
- Protección contra doble clic (*idempotency*).

---

## 📦 Descarga del APK
Descarga el archivo APK firmado adjunto en este release e instálalo directamente en tu dispositivo Android (`minSdk 26` / Android 8.0+).
