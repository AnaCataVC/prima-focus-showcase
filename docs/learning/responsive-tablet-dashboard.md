# Arquitectura Responsiva: Tablet Dashboard

**Fecha:** Agosto 2026

## Contexto
Durante la optimización para tablets de Prima-Focus, notamos que estirar la lista de tareas (`HomeScreen` / `TaskListScreen`) para que ocupe todo el ancho de una pantalla de 10+ pulgadas resultaba en un enorme desperdicio de espacio y un diseño visualmente pobre, en especial en modo apaisado (Landscape). Además, el Calendario en modo vertical ocupaba demasiado espacio.

## Decisión: Dashboard Orquestador

Para resolver esto, decidimos implementar un componente dedicado: `TabletDashboardScreen`. Este componente actúa como un contenedor orquestador de dos de los widgets principales de la app:
1. Las Tareas (a la izquierda/arriba).
2. El Calendario (a la derecha/abajo).

### Patrón de Layout Adaptativo

Para evitar mantener dos estructuras completamente diferentes, la pantalla evalúa la orientación del dispositivo en tiempo real y asigna contenedores y pesos:

```kotlin
val configuration = LocalConfiguration.current
val isLandscape = configuration.orientation == Configuration.ORIENTATION_LANDSCAPE

if (isLandscape) {
    Row(modifier = Modifier.fillMaxSize()) {
        Box(modifier = Modifier.weight(0.5f)) { HomeScreen(...) }
        Box(modifier = Modifier.weight(0.5f), contentAlignment = Alignment.Center) { CalendarWidget(...) }
    }
} else {
    Column(modifier = Modifier.fillMaxSize()) {
        Box(modifier = Modifier.weight(0.5f)) { HomeScreen(...) }
        Box(modifier = Modifier.weight(0.5f), contentAlignment = Alignment.Center) { CalendarWidget(...) }
    }
}
```

### Alineación del Calendario (`Alignment.Center`)
**Lección Crítica:** Inicialmente, el widget del calendario en tablet quedaba "pegado" al borde superior (en Landscape) o dejaba un gran espacio vacío debajo (en Portrait). Al embeber widgets autónomos en cuadrículas (como en mitades de pantalla `weight(0.5f)`), el componente interno no siempre expandirá todo el tamaño a menos que se fuerce. 
La forma más limpia de arreglar esto y mantener armonía asimétrica fue delegar la alineación al contenedor Padre (`Box`) usando `contentAlignment = Alignment.Center`, asegurando que el widget (cuyo tamaño interno depende del mes) siempre flote en el medio exacto de su zona designada.

### Optimización de Estado
Para mostrar indicadores térmicos (Heatmap) en el Calendario sin matar el rendimiento de redibujado:
- Extraemos la lista reactiva de `pendingTasks`.
- Calculamos el mapa de frecuencias (`workloadMap`) agrupado por fecha a nivel del Dashboard usando `remember`.
- Se lo inyectamos al componente hijo estático. De este modo, la pesada lógica de `groupBy` y conteo se evalúa únicamente cuando cambian las tareas, no cada vez que cambia un día seleccionado o una pequeña animación en el calendario.
