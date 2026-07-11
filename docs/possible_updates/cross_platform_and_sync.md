# Actualización Futura: Multiplataforma y Sincronización en la Nube

Originalmente, Prima-Focus fue diseñado con una arquitectura "Offline-First" más compleja que incluía soporte para múltiples plataformas y sincronización en la nube. Esta documentación se guarda aquí para referencia futura en caso de que el proyecto requiera escalar.

## 1. Arquitectura de Doble Cliente (Dual-Client)
La idea era mantener dos clientes sincronizados a través de un backend común:

*   **Android Native:** Construido con Kotlin y Jetpack Compose, usando Room para la base de datos local y WorkManager para tareas en segundo plano.
*   **Web PWA (Progressive Web App):** Construido con React, Vite e IndexedDB para almacenamiento local. Estaba diseñado con un layout de 3 columnas para aprovechar el espacio en pantallas de escritorio, y utilizaba Service Workers y la Web Push API para las notificaciones.

## 2. Sincronización con Firestore (Sync Queue)
Para asegurar que los usuarios nunca fueran bloqueados por una mala conexión a internet, se diseñó el siguiente flujo:

1.  **Local-First:** Todas las operaciones (crear, editar, borrar tareas o sesiones) se escribían *primero* en la base de datos local (Room o IndexedDB).
2.  **Banderas de Sincronización:** Cada registro en la base de datos tenía dos columnas adicionales:
    *   `dirty` (Boolean/Integer): Marcado como `true` (1) cada vez que el registro era modificado localmente y aún no había sido subido a la nube.
    *   `version` (Integer): Un contador que se incrementaba en 1 con cada edición local, útil para resolver conflictos en la nube.
3.  **El "Sync-Agent":** Un proceso en segundo plano (WorkManager en Android, Service Worker en Web) que monitoreaba la conectividad. Cuando había internet, buscaba todos los registros donde `dirty == true` y los enviaba a Firebase Firestore.
4.  **Confirmación:** Si Firestore aceptaba los datos exitosamente, el Sync-Agent actualizaba el registro local para marcar `dirty = false`.

## 3. Resolución de Conflictos (Last-Write-Wins)
Dado que ambos clientes (Móvil y Web) podían editar la misma tarea simultáneamente estando offline, la resolución de conflictos en Firestore se planeaba así:
*   Al intentar sincronizar, Firestore comparaba el `version` y el `updatedAt` del documento entrante con el almacenado.
*   Se aplicaba una estrategia de "Last-Write-Wins" (La última escritura gana) basándose en el `updatedAt`, o se intentaba un *merge* en el cliente si las propiedades editadas eran distintas (ej. el teléfono actualizó la fecha, pero la web actualizó el título).

## 4. Notas sobre Notificaciones
*   Para la web, se requerían Cloud Functions opcionales en Firebase para programar recordatorios en el servidor y disparar alertas Push (FCM) al navegador si este no estaba en ejecución.
*   El cálculo de la prioridad (`priorityScore`) debía ser implementado de manera idéntica tanto en el motor TypeScript de la Web como en el motor Kotlin de Android.
