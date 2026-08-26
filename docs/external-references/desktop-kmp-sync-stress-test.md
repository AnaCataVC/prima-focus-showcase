> **Created:** 2026-08-26
> **Last Updated:** 2026-08-26

# Adversarial Stress-Test: App Desktop Nativa (Compose Multiplatform) con Sincronización LAN P2P

Este documento registra la auditoría de equipo rojo (*Red Team Premortem Analysis*) bajo la directiva `ami-stress-test-idea` para la arquitectura Desktop y sincronización LAN de Prima-Focus.

---

## 1. Modos de Falla Operacionales y de Red (Premortem)
- **[Crítico / Bloqueador] Aislamiento de Red Wi-Fi (AP Client Isolation):**
  - En redes públicas, de oficina o universitarias, los routers bloquean la comunicación directa P2P entre dispositivos.
  - **Mitigación:** Mecanismo de respaldo offline mediante exportación/importación de archivos JSON (compatible con SAF en Android y Drag & Drop en PC).
- **[Mayor / Requiere Blindaje] Interfaces de Red Múltiples (VPNs / WSL):**
  - Múltiples adaptadores virtuales pueden desviar el descubrimiento mDNS.
  - **Mitigación:** Escanear y vincular sockets a todas las interfaces no-loopback activas.

---

## 2. Concurrencia, Condiciones de Carrera y State Drift
- **[Mayor / Requiere Blindaje] Sobrescritura de Estado Completado:**
  - En modificaciones concurrentes offline, un desempate ciego LWW podría devolver una tarea completada al estado pendiente.
  - **Mitigación:** Regla semántica de merge: el estado `COMPLETED` es irreversible por timestamps desfasados, preservando la precedencia de `syncVersion`.

---

## 3. Rendimiento y Recursos
- **[Mayor / Requiere Blindaje] Huella de Memoria JVM en Desktop:**
  - Consumo de 150-300MB si no se optimiza el empaquetado.
  - **Mitigación:** Empaquetado `jpackage` con `jlink` para recortar módulos de runtime innecesarios y suspender recomposiciones al minimizar al System Tray.

---

## 4. Seguridad y Abuso en LAN
- **[Crítico / Bloqueador] Suplantación e Inyección de Payloads en Redes Abiertas:**
  - Un endpoint LAN sin autenticación permitiría inyectar tareas falsas o borrar la base de datos con `syncVersion` inflado.
  - **Mitigación Obligatoria:** Emparejamiento por PIN de 6 dígitos de un solo uso e intercambio de tokens de sesión firmados con HMAC-SHA256.
- **[Mayor / Requiere Blindaje] Bloqueo por Firewall de Windows:**
  - **Mitigación:** Autodiagnóstico de conectividad integrado en la UI y manejo de puertos alternativos.
