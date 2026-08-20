# UX Pattern: Flujo de Formularios en Modales Transparentes

**Fecha:** Agosto 2026

## Contexto
Durante el rediseño del `InboxModal` (la pantalla para agregar tareas de forma rápida), implementamos una estética Glassmorphism flotante (un `ModalBottomSheet` con color base transparente). Esto trajo dos retos importantes de usabilidad y diseño.

## 1. El Flujo de Acción (Ubicación del Botón de Enviar)

**Problema Inicial:**
El botón primario ("Guardar Tarea") era un botón circular flotante posicionado en la parte superior derecha, justo al lado del primer campo de texto (Título de la tarea). Sin embargo, el formulario contenía más campos debajo (Categoría, Duración estimada, Fecha, Recurrencia).

**Lección Aprendida:**
Tener el botón primario de acción (Call To Action o CTA) inmediatamente después del primer campo invita al usuario a enviar el formulario de manera prematura, saltándose los campos inferiores. El ojo humano sigue un patrón de lectura descendente en este tipo de modales.

**Solución Implementada:**
- **Remover** el botón de guardado de la cabecera, dándole todo el ancho al campo de Título.
- **Anclar** un botón grande de "Guardar Tarea" al final del formulario (`Column`).
- Al forzar al usuario a llegar hasta el fondo para guardar, naturalmente escaneará y rellenará las opciones intermedias, haciendo el flujo mucho más intuitivo.

## 2. Legibilidad sobre Fondos Transparentes

**Problema Inicial:**
Al configurar el `ModalBottomSheet` con `containerColor = Color.Transparent` y usar un fondo translúcido (`glassSurface`) para que se viera el contenido detrás (la lista de tareas o calendario), el texto del modal se mezclaba con el texto subyacente de la app, arruinando por completo la legibilidad.

**Lección Aprendida y Solución:**
En componentes flotantes que contienen mucho texto o inputs, la transparencia absoluta es perjudicial. Es estrictamente necesario añadir una capa base "casi opaca" antes de aplicar el efecto cristal.
```kotlin
// Forma Correcta:
Modifier
    .background(glows.backgroundCenter.copy(alpha = 0.95f)) // Bloqueador de texto subyacente
    .background(glows.glassSurface) // Efecto cristal superior
```
De esta forma se preserva la textura y la paleta de colores del efecto Glassmorphism, pero se bloquea visualmente lo que está detrás.
