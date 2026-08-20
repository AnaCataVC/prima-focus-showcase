### 📱 Adaptive Tablet UI, Offline P2P Sync & Atomic Task Model / UI Adaptativa para Tablets, Sync P2P Offline y Modelo de Tareas Atómicas

#### English
* **Responsive Tablet Dashboard & Interactive Calendar:** Native split-view experience for expanded screens (`WindowSizeClass`), featuring a dedicated interactive calendar sidebar to filter and schedule tasks by date.
* **Offline Local-First P2P Sync:** Fast and private peer-to-peer synchronization across local devices using the Google Nearby Connections API, with deterministic *Last-Write-Wins* conflict resolution.
* **Atomic Task Completion Model:** Completely removed duration inputs (`estimatedMinutes`), time chips, and mandatory timers. Tasks now operate as streamlined, actionable atomic units (*Done / Pending*).
* **Direct Completion UI:** The Hero Focus card now features a prominent 80dp Checkmark FAB with an instant "Undo" Snackbar to effortlessly mark tasks as completed.
* **Refined Deterministic Priority Formula:** Mathematical formula without duration penalties, introducing floor protection at 0.0 to prevent stale tasks from acquiring negative scores.
* **Instant Task Capture:** Streamlined Inbox modal for lightning-fast task creation without cognitive friction.
* **SAF Backup & Relational History:** Safe JSON import/export via Storage Access Framework and paired session sentiment tracking (`TaskWithSessions`).

#### Español
* **Dashboard Adaptativo para Tablets y Calendario Interactivo:** Experiencia nativa en pantalla dividida (Split-View) para pantallas grandes (`WindowSizeClass`), con panel lateral de calendario interactivo para filtrar y gestionar tareas por fecha.
* **Sincronización P2P Offline (Local-First):** Sincronización directa y privada entre dispositivos cercanos mediante Google Nearby Connections API, con resolución determinista de conflictos vía *Last-Write-Wins*.
* **Modelo de Tareas Atómicas:** Eliminación total de la estimación de minutos (`estimatedMinutes`), chips de duración y temporizadores forzados. Las tareas ahora funcionan como unidades de acción puras (*Hecha / Pendiente*).
* **Interfaz de Completado Directo:** La tarjeta principal Hero cuenta con un botón central de 80dp con icono de Checkmark y soporte para "Deshacer" inmediato vía Snackbar.
* **Motor de Priorización Refinado:** Fórmula matemática determinista sin penalizaciones de duración, con piso protector en 0.0 que evita puntajes negativos en tareas antiguas.
* **Captura Ultrarrápida:** Modal de Inbox optimizado para crear tareas en segundos sin fricción cognitiva.
* **Respaldo SAF e Historial Relacional:** Exportación/importación segura en JSON vía Storage Access Framework y seguimiento relacional de sesiones (`TaskWithSessions`).
