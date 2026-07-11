# Congelamientos en Jetpack Compose con LazyColumn (Gotcha)

## El Problema
Al intentar eliminar o reorganizar elementos dinámicos dentro de una lista en Jetpack Compose, específicamente usando `LazyColumn`, la aplicación experimentaba congelamientos severos o caídas.

## La Lección
Este comportamiento se debe a que Compose no puede rastrear eficientemente el estado de los elementos cuando su posición en la lista cambia o se eliminan, a menos que se le provea un identificador único constante. Sin una clave (key), Compose intenta recomponer los elementos basándose en su posición en la lista, lo que genera desajustes de estado y fallos de rendimiento (recompositions loop o IndexOutOfBounds).

## La Solución
Se debe usar siempre el parámetro `key` en la función `items()` de un `LazyColumn` cuando los elementos son mutables:

```kotlin
LazyColumn {
    items(
        items = taskList,
        key = { task -> task.taskId } // Clave única y estable
    ) { task ->
        TaskItem(task)
    }
}
```
Esto estabiliza la recomposición permitiendo a Compose rastrear elementos independientemente de su posición.
