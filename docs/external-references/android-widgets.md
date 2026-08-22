# Android Home Screen Widgets — Technical Reference

This document outlines the architecture, layout system, dynamic sizing mechanism, and interaction flows for the home screen widgets implemented in **Prima-Focus** using **Jetpack Glance**.

---

## 1. Overview & Architecture

Prima-Focus provides two native home screen widgets powered by Jetpack Glance (Compose runtime for `RemoteViews`):

1. **Top Three Tasks Widget (`TopThreeTasksWidget`)**:
   - Displays the top 3 prioritized tasks dynamically retrieved from the local Room database (`taskDao.getTopThreeTasksNow()`).
   - Supports direct interactive task completion right from the widget via Glance action callbacks.
   - Shows priority indicators with dynamic semantic color tokens matching the in-app glassmorphism design.

2. **Quick Add Task Widget (`QuickAddWidget`)**:
   - Provides instant category chips (`Trabajo`, `Salud`, `Casa`) and dynamic input triggers.
   - Launches the app directly into the quick-add creation flow via deep linking / Intent targets.

---

## 2. Dynamic Sizing & Responsive Metrics (`SizeMode.Exact`)

Home screen widgets can be resized across varying grid cell configurations (e.g., 4x2, 4x3, 4x4). Standard static dimensions lead to clipped content or awkward dead space beneath task rows.

### Implementation Pattern

By declaring `override val sizeMode = SizeMode.Exact`, the widget runtime evaluates `LocalSize.current` to derive proportional layout dimensions at runtime:

```kotlin
class TopThreeTasksWidget : GlanceAppWidget() {
    override val sizeMode = SizeMode.Exact
    // ...
}
```

### Proportional Row Metrics (`RowMetrics`)

Dimensions such as title typography, button diameter, and category text sizes scale smoothly with available container height:

```kotlin
private class RowMetrics(availableHeight: Float, rowCount: Int) {
    private val slot = (availableHeight / rowCount.coerceAtLeast(1)).coerceAtLeast(36f)

    val title = (slot * 0.26f).coerceIn(14f, 26f)
    val category = (title * 0.75f).coerceIn(11f, 18f)
    val header = (title * 0.8f).coerceIn(12f, 17f)
    val button = (slot * 0.52f).coerceIn(28f, 48f)
    val dot = (button * 0.3f).coerceIn(8f, 14f)
}
```

---

## 3. Interactive Callbacks

Widgets utilize `ActionCallback` handlers to perform direct database modifications without needing to bring the full application to the foreground:

```kotlin
class CompleteTaskGlanceAction : ActionCallback {
    override suspend fun onAction(
        context: Context,
        glanceId: GlanceId,
        parameters: ActionParameters
    ) {
        val taskId = parameters[TaskIdKey] ?: return
        val db = PrimaFocusDatabase.getDatabase(context)
        db.taskDao().completeTask(taskId, System.currentTimeMillis())
        TopThreeTasksWidget().update(context, glanceId)
    }
}
```

---

## 4. Widget Picker Previews (XML Layouts)

To ensure pixel-perfect fidelity in the Android widget picker preview prior to placement on the home screen:
- Previews are scaffolded in XML (`res/layout/widget_top_three_preview.xml` and `res/layout/widget_quick_add_preview.xml`).
- They mirror the exact visual hierarchy, corner radii (`@drawable/widget_rounded_bg`), and typography tokens defined in the Glance Composables.
