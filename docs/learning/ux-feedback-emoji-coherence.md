# Coherencia Semántica en Captura e Historial de Feedback (Patrón UX)

## El Problema
Existía una disparidad entre los emojis presentados al usuario al completar una sesión en el modal de revisión rápida (\QuickReviewModal.kt\) y los emojis renderizados posteriormente en el historial de tareas completadas (\TaskViewModel.kt\ / \TaskListScreen.kt\). El usuario seleccionaba un estado de ánimo y observaba un emoji diferente en su registro histórico, generando confusión y disonancia cognitiva.

## La Solución
Se unificó la escala de feedback a 3 estados consistentes tanto en la captura como en la visualización:
- **1 (Mal / Baja satisfacción)**: 😐
- **3 (Normal / Satisfactorio)**: 😊
- **5 (Excelente / Alta satisfacción)**: 😁

## Impacto
- **Consistencia Visual**: El usuario reconoce inmediatamente en su historial la misma representación gráfica elegida al finalizar su bloque de enfoque.
- **Trazabilidad Predictible**: Se preserva la correlación exacta entre los enteros almacenados en base de datos (\Room\ / \SessionEntity.feeling\) y los componentes de la interfaz de usuario en Jetpack Compose.
