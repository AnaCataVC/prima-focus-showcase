# Technical Reference: Task Prioritization Without Timing & Duration Dependencies

> **Created:** 2026-08-20  
> **Last Updated:** 2026-08-20  
> **Author:** Architecture & Adversarial Audit Team  
> **Context:** Prima-Focus Android App  

---

## 1. Executive Summary & Problem Space

The original Prima-Focus architecture used time estimations (`estimatedMinutes`) in two core areas:
1. **Mathematical Prioritization Formula:** Penalizing longer tasks with `-0.02 * estimatedMinutes` and automatically flagging tasks with `estimatedMinutes > 120` as projects.
2. **Execution UI (Pomodoro / Timer Focus):** The primary call to action (CTA) on the Hero Card was a large "Play" FAB that launched a countdown timer (`TimerScreen` + foreground `TimerService`).

### The Challenge & Audit Findings
Removing timing converts tasks into **atomic binary items** (Done vs. Not Done / Pending). An adversarial audit identified key failure modes that must be mathematically and architecturally guarded:
- **Negative Age Decay Risk:** Without a minimum clamp on base score, aged tasks could drop into negative scores and get overtaken by fresh trivial tasks even if scheduled for "Hoy".
- **Dynamic Urgency 24h Window Overlap:** Tasks scheduled for "Mañana" could receive same-day urgency if checked within 24 hours of midnight.
- **Accidental Completion in UX:** A large 80dp action button requires an immediate "Deshacer" (Undo) mechanism and a permanently accessible Completed tab.
- **Phantom Session Durations:** Completing tasks without durations must not inject default 25-minute fake sessions into Room.

---

## 2. Hardened Prioritization Engine (Mathematical Definition)

### 2.1 Formula Definition
$$\text{priorityScore} = \text{scoreBase} + \text{scoreDynamic} + \text{manualBoost}$$

### 2.2 Static Base Score Calculation
```kotlin
// 1. Calculate static base score with absolute floor at 0.0 to prevent negative decay
val scoreBaseStatic = ((10.0 * task.categoryWeight) - (0.5 * ageDays)).coerceAtLeast(0.0)

// 2. High priority floor: Critical categories (salud, trámites urgentes, etc.) are clamped to at least 70.0
val scoreBase = if (task.categoryWeight >= 4.0) {
    scoreBaseStatic.coerceAtLeast(70.0)
} else {
    scoreBaseStatic
}
```

### 2.3 Hardened Dynamic Urgency (Calendar Hierarchy)
```kotlin
val isOverdue = scheduledDate != null && scheduledDate.isBefore(currentDate)
val isToday = scheduledDate == currentDate
val isTomorrow = scheduledDate == currentDate.plusDays(1)

val scoreDynamic = when {
    // Overdue tasks receive maximum urgency (+6 date + 8 overdue = +14)
    isOverdue -> if (task.recurrence != null) 14.0 else 14.0
    
    // Tasks scheduled for today dominate:
    // If specific time is set, scale urgency (within 2h = +14, rest of day = +10.8)
    // If no specific time, constant +10.8 to prevent late-night cognitive anxiety
    isToday -> if (task.hasTime && task.time != null) (6.0 + 8.0 * timeUrgency) else 10.8
    
    // Tomorrow tasks get moderate visibility without overtaking today's tasks
    isTomorrow -> 4.0
    
    // Future scheduled dates get a mild date presence
    scheduledDate != null -> 2.0
    
    // Unscheduled backlog
    else -> 0.0
}
```

---

## 3. UX & Safety Mitigations

1. **Undo Mechanism on Hero Card & Task List:**
   - Every task completion triggers a Snackbar with an active **"Deshacer" (Undo)** action button that invokes `viewModel.uncompleteTask(task)`.
2. **Completed Tasks History Accessibility:**
   - The "Historial / Completadas" tab in `TaskListScreen` remains accessible at all times so completed tasks never vanish into a void.
3. **Clean Session Records:**
   - Tasks completed directly record `durationMinutes = null` and `mode = "direct_complete"`.
   - In `TaskListScreen`, history items display `"Completada directamente"` instead of a hardcoded 25 min duration.
4. **P2P Sync Normalization:**
   - Incoming tasks from remote devices in `syncMergeData` are passed through `PriorityEngine.calculatePriority()` before writing to local Room DB.
5. **Widget Alignment:**
   - `TopTaskWidgetProvider` updates its display to show `• Categoría` and launches the app directly into the task context.
