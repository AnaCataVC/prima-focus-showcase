> **Created:** 2026-08-26
> **Last Updated:** 2026-08-26

# Adversarial Stress-Test: Desktop Companion — JFrame Invisible & Launch Failures

---

## Causa Raiz del JFrame Invisible (Hallazgo Critico — Confirmado)

La cadena de falla exacta es:

1. `view.show()` dentro del `SwingUtilities.invokeAndWait {}` falla con una excepcion.
2. El `catch (ex: Exception)` interno la captura y solo imprime a `System.err`.
3. **Con `javaw.exe` no hay consola visible** — el error desaparece por completo.
4. `invokeAndWait` retorna normalmente.
5. `main()` retorna inmediatamente.
6. El proceso queda vivo **unicamente** porque `newCachedThreadPool()` crea threads **non-daemon**.
7. El HTTP server sigue corriendo (PIN y puerto se loggean correctamente).
8. Pero `MainWindowHandle = 0` porque el JFrame **nunca se mostro**.

---

## Critical Failure Modes

### [P0 Critical] — SQLite JDBC DLL Extraction Failure on Windows
El driver `sqlite-jdbc-3.45.2.0.jar` extrae `.dll` nativos a `%TEMP%`. Windows Defender puede bloquear esta extraccion silenciosamente, causando `UnsatisfiedLinkError` en `DesktopDatabaseManager.init{}`, que mata el EDT sin mostrar nada.

**Fix:** Forzar `org.sqlite.tmpdir` a `%APPDATA%\PrimaFocus\`:
```kotlin
System.setProperty("org.sqlite.tmpdir", dir.absolutePath)
```

### [P0 Critical] — Silent Exception Swallowing con javaw.exe
`System.setProperty("sun.awt.exception.handler", "java.lang.RuntimeException")` descarta errores EDT silenciosamente en Java 17. Con `javaw.exe` sin consola, cualquier excepcion es invisible.

**Fix:** Redirigir `System.err` a un archivo de log al inicio:
```kotlin
val logFile = File(System.getenv("APPDATA") ?: System.getProperty("user.home"), "PrimaFocus/launch.log")
val logStream = java.io.PrintStream(logFile, "UTF-8")
System.setErr(logStream)
System.setOut(logStream)
```

### [P0 Critical] — `refreshTasks()` con `invokeLater` anidado en `invokeAndWait`
`show()` llama `refreshTasks()` que hace `SwingUtilities.invokeLater {}` — anidado dentro del `invokeAndWait`. La carga de tareas se posterga y si lanza excepcion, no hay ningun catch.

**Fix:** Llamada sincrona en el EDT:
```kotlin
private fun loadTasksSync() {
    taskListModel.clear()
    try {
        dbManager.getPendingActiveTasks().forEach { taskListModel.addElement(it) }
        titleLabel.text = "Tareas Priorizadas (${taskListModel.size()} pendientes)"
    } catch (ex: Exception) {
        titleLabel.text = "Error al cargar tareas: ${ex.message}"
    }
}

fun refreshTasks() {
    if (SwingUtilities.isEventDispatchThread()) loadTasksSync()
    else SwingUtilities.invokeLater { loadTasksSync() }
}
```

---

## Major Vulnerabilities

### [P1 Major] — SQLite sin WAL mode → SQLITE_BUSY Deadlocks
El `HttpServer` (threads non-daemon) escribe en SQLite mientras el EDT lee. Sin WAL mode, el lock exclusivo de escritura bloquea los readers.

**Fix en `initSchema()`:**
```kotlin
stmt.execute("PRAGMA journal_mode=WAL;")
stmt.execute("PRAGMA busy_timeout=5000;")
stmt.execute("PRAGMA synchronous=NORMAL;")
```

### [P2 Major] — HTTP Sync Endpoint sin validacion de tamano de payload
`gson.fromJson(body, LANSyncPacket::class.java)` sin limite de tamano. Un atacante LAN puede enviar un payload masivo causando OOM.

**Fix:**
```kotlin
if (exchange.requestBody.available() > 10 * 1024 * 1024) {
    sendResponse(exchange, 413, """{"error":"Payload too large"}""")
    return
}
```

---

## Recommended Hardening Mitigations (Priority Order)

| Priority | Fix | File | Effort |
|----------|-----|------|--------|
| P0 | Redirigir System.err a launch.log | Main.kt | 10 min |
| P0 | Forzar org.sqlite.tmpdir a %APPDATA%/PrimaFocus/ | DesktopDatabaseManager.kt | 5 min |
| P0 | Reemplazar invokeLater anidado con loadTasksSync() | DesktopMainView.kt | 15 min |
| P0 | Eliminar sun.awt.exception.handler property | Main.kt | 2 min |
| P1 | Activar SQLite WAL mode + busy_timeout=5000 | DesktopDatabaseManager.kt | 5 min |
| P1 | Catch Throwable (no solo Exception) en bloque EDT | Main.kt | 5 min |
| P2 | Limite de tamano de payload HTTP sync | DesktopSyncServer.kt | 10 min |
