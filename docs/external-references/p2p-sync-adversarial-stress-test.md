> **Created:** 2026-08-23  
> **Last Updated:** 2026-08-23  

# Adversarial Stress-Test & Premortem: P2P Synchronization (Prima-Focus)

Este informe expone los vectores de falla crítica, condiciones de carrera, riesgos de seguridad y degradaciones de rendimiento identificados mediante un análisis de Red Team / Abogado del Diablo sobre el plan de sincronización P2P local.

---

## 1. Vectores de Falla Crítica y Vulnerabilidades

### [VULN-01] [Severidad: CRÍTICA] Desfase de Relojes Locales (*Clock Drift*) en Last-Write-Wins (LWW)
- **Mecanismo de Falla:** LWW se basa en comparar `received.updatedAt > local.updatedAt`. Si el Dispositivo A tiene su reloj del sistema adelantado apenas 2 minutos respecto al Dispositivo B (por sincronización NTP desfasada o ajuste manual), **todas las ediciones realizadas en el Dispositivo B serán descartadas silenciosamente por el Dispositivo A**, provocando pérdida de datos irrecuperable sin que el usuario lo note.
- **Mitigación / Endurecimiento:**
  - Si la diferencia de timestamps entre ambos dispositivos al momento del handshake inicial es mayor a $\pm 30$ segundos, registrar el `clockOffset` o usar un contador lógico incremental (`lamportTimestamp` o `version: Long`) en cada entidad para desempatar ediciones en vez de depender ciegamente del reloj del sistema.

---

### [VULN-02] [Severidad: ALTA] Conexión Ciega y Riesgo de Inyección / Spoofing en Red Local
- **Mecanismo de Falla:** `P2PSyncManager` ejecuta `connectionsClient.acceptConnection(...)` de manera **automática** sin validar tokens de autenticación ni pedir confirmación al usuario.
- **Impacto:** En una red Wi-Fi compartida (cafetería, oficina, universidad), cualquier dispositivo que emita bajo el mismo `SERVICE_ID` puede conectarse e inyectar payloads arbitrarios con `isDeleted = true`, borrando las tareas del usuario legítimo.
- **Mitigación / Endurecimiento:**
  - Mostrar un diálogo de confirmación en pantalla con el nombre del dispositivo entrante antes de invocar `acceptConnection`, o validar el token de autenticación que genera la API de Nearby (`ConnectionInfo.authenticationDigits`).

---

### [VULN-03] [Severidad: MEDIA/ALTA] Sobrecarga de Transferencia y Memoria (*Full-State vs Delta-Sync*)
- **Mecanismo de Falla:** El plan actual envía **todas las tareas y sesiones históricas** (`getAllTasks()`) en cada sincronización.
- **Impacto:** Tras 6 meses de uso con cientos de sesiones Pomodoro y tareas acumuladas, el payload JSON superará varios megabytes. Esto causará lentitud en la serialización Gson, alto uso de CPU y demoras en la transferencia BLE/Wi-Fi Direct.
- **Mitigación / Endurecimiento:**
  - Implementar **Sincronización Incremental (Delta Sync):** En el handshake inicial, cada dispositivo comparte su `lastSyncTimestamp`. Solo se transmiten las entidades donde `updatedAt > peerLastSyncTimestamp`.

---

### [VULN-04] [Severidad: MEDIA] Acumulación Indefinida de *Tombstones* (Inflación de BD)
- **Mecanismo de Falla:** Si las tareas eliminadas lógicamente (`isDeleted = true`) nunca se eliminan físicamente de SQLite, la base de datos crecerá indefinidamente con basura histórica.
- **Mitigación / Endurecimiento:**
  - Implementar una regla de **Purga de Tombstones (Garbage Collection):** Borrado físico (`DELETE WHERE isDeleted = 1 AND deletedAt < (now - 30_DIAS)`) que se ejecute en segundo plano o al iniciar la app.

---

### [VULN-05] [Severidad: MEDIA] Conflicto de Edición Concurrente Multicampo
- **Mecanismo de Falla:** Si el usuario edita el título de la tarea en el teléfono a las 10:00 (offline) y en la tablet completa esa misma tarea a las 10:01 (offline), la estrategia LWW completa descarta por completo la edición del título del teléfono porque el registro de la tablet tiene un `updatedAt` más reciente.
- **Mitigación / Endurecimiento:**
  - En el merge atómico, priorizar la conservación de campos de estado (`status = completed`) y respetar la versión más reciente del texto, o documentar explícitamente a nivel de producto que la granularidad de LWW es a nivel de entidad completa.

---

## 2. Matriz de Endurecimiento Recomendada

| Vulnerabilidad | Nivel de Riesgo | Acción Inmediata de Endurecimiento |
| :--- | :--- | :--- |
| **Clock Drift (Desfase de horas)** | 🔴 Crítico | Agregar `version: Long` incremental en cada edición de `TaskEntity`. |
| **Aceptación Ciega de Conexión** | 🟠 Alto | Confirmar `authenticationDigits` o mostrar diálogo de aceptación con nombre del dispositivo. |
| **Full-State Sync Payload Bloat** | 🟡 Medio | Sincronizar solo tareas activas y sesiones recientes / delta sync. |
| **Tombstones Infinitos** | 🟡 Medio | Purga automática de registros eliminados con más de 30 días de antigüedad. |
