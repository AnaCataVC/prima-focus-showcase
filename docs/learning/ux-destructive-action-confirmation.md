# UX Pattern: Destructive Action Confirmation with AlertDialog in Compose

**Date:** August 2026
**Screen:** HomeScreen — Hero Task Card

## Context & Decision

When a user taps "Delete" on the Hero Task Card (the highest-priority task), the deletion is permanent and cannot be undone via Snackbar (unlike secondary cards, where an Undo Snackbar is feasible). To prevent accidental permanent deletions — especially critical for neurodivergent users who may act impulsively — an explicit confirmation step was introduced.

## Implementation Pattern

Use a local boolean state variable scoped inside the composable block that owns the destructive action. Show an `AlertDialog` when that state is `true`.

```kotlin
// 1. Declare state (scoped inside the parent 'if heroTask != null' block)
var showDeleteConfirmDialog by remember { mutableStateOf(false) }

// 2. Trigger state from the Delete button
IconButton(onClick = { showDeleteConfirmDialog = true }) {
    Icon(Icons.Default.Delete, contentDescription = "Eliminar")
}

// 3. Render dialog conditionally
if (showDeleteConfirmDialog) {
    AlertDialog(
        onDismissRequest = { showDeleteConfirmDialog = false },
        title = { Text("¿Eliminar tarea?") },
        text = { Text("Esta acción es permanente y no se puede deshacer.") },
        confirmButton = {
            Button(
                onClick = {
                    showDeleteConfirmDialog = false
                    viewModel.deleteTask(heroTask.taskId)
                },
                colors = ButtonDefaults.buttonColors(containerColor = MaterialTheme.colorScheme.error)
            ) { Text("Eliminar") }
        },
        dismissButton = {
            TextButton(onClick = { showDeleteConfirmDialog = false }) { Text("Cancelar") }
        }
    )
}
```

## Key Design Decisions

- **State scoping:** declared inside the `if (heroTask != null)` block to prevent stale state.
- **Error color on confirm button:** reinforces the destructive nature (Material 3 standard).
- **No Undo Snackbar on hero delete:** pre-confirmation dialog replaces post-action undo for irreversible actions.
- **Dismiss on background tap:** `onDismissRequest` safely cancels the flow.

## When to Apply This Pattern

Use **pre-confirmation AlertDialog** instead of **post-action Undo Snackbar** when:
1. The action is truly irreversible.
2. The item is high-value or hard to recreate.
3. Accidental taps are likely.

Use **Undo Snackbar** (no dialog) when:
1. An undo operation exists (e.g., `restoreTask()`).
2. The item is low-stakes.
3. Friction must be minimized (bulk operations, secondary list items).
