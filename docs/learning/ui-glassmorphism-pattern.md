# UI Pattern: Premium Glassmorphism en Jetpack Compose

**Fecha:** Agosto 2026

## Contexto y Decisión
Para elevar la calidad visual de la aplicación Prima-Focus, decidimos abandonar los fondos sólidos y oscuros tradicionales y transicionar hacia una estética de **"Premium Glassmorphism"**. Esta decisión se aplicó transversalmente en la lista de tareas, el calendario, el modal de creación y la pantalla de ajustes.

## Patrón de Implementación
Para lograr el efecto de "cristal esmerilado con volumen y destellos" sin comprometer el rendimiento, estandarizamos el siguiente patrón en Jetpack Compose:

1. **Superficie Translúcida:**
   Un fondo base con baja opacidad que simula el cristal.
   ```kotlin
   Modifier.background(glows.glassSurface) // Usualmente un color con alpha bajo
   ```

2. **Bordes Iluminados (Glass Edge):**
   Un borde de 1dp usando un gradiente lineal para simular cómo la luz se refleja en los bordes del cristal.
   ```kotlin
   Modifier.border(
       width = 1.dp,
       brush = Brush.linearGradient(listOf(glows.glassBorderStart, glows.glassBorderEnd)),
       shape = RoundedCornerShape(...)
   )
   ```

3. **Destellos Interiores (Inner Glow):**
   Luz volumétrica detrás del contenido para dar profundidad. Se dibuja *detrás* del componente usando `drawBehind`.
   ```kotlin
   Modifier.drawBehind {
       drawCircle(
           brush = Brush.radialGradient(
               colors = listOf(glows.primaryGlow.copy(alpha = 0.15f), Color.Transparent),
               center = androidx.compose.ui.geometry.Offset(this.size.width / 2f, 0f),
               radius = this.size.width
           )
       )
   }
   ```

## Gotchas y Lecciones Aprendidas
- **Ambigüedad de Scope (`size`):** Al usar `drawBehind`, si el modificador se usa en un contexto donde ya existe una variable o función `size` (por ejemplo, al importar `Modifier.size()`), el compilador de Kotlin puede confundirse y fallar la compilación con `Unresolved reference`. 
  - **Solución:** Siempre usar explícitamente `this.size.width` o `this.size.height` para asegurar que referenciamos el `DrawScope`.
- **Rendimiento:** Al basarse en dibujo nativo (Canvas via `drawBehind`) en lugar de apilar múltiples vistas `Box`, mantenemos el árbol de composición ligero y evitamos sobrecarga de renderizado.
