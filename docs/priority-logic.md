# Priority Logic

The core value of Prima-Focus is its deterministic and reproducible task prioritization formula.

## The Formula

The Priority Score is calculated by splitting the factors into a **Base Score** (static importance/cost) and a **Dynamic Urgency** component:

`priorityScore = baseScore + dynamicUrgency + manualBoost`

### 1. Base Score (Static component)
`baseScoreStatic = 10 * categoryWeight - 2 * ln(1 + subtasksCount) - 0.02 * estimatedMinutes - 0.5 * ageDays`

- **High Priority Floor (Rule)**: If `categoryWeight >= 4.0`, the base score is clamped to a minimum of `70.0`:
  `baseScore = max(70.0, baseScoreStatic)`
  Otherwise:
  `baseScore = baseScoreStatic`

### 2. Dynamic Urgency (Time component)
`dynamicUrgency = 6 * hasDate + 8 * timeUrgency`

### Variables
- **categoryWeight**: Float mapped from the task's category and subcategory (see `categories.md`).
- **hasDate**: Boolean (1 if true, 0 if false).
- **timeUrgency**: 
  - If the task has a specific time (`hasTime = true`):
    - `1.0` if the scheduled time is within the next 2 hours or is overdue (past due).
    - `0.6` if the scheduled time is within the next 24 hours.
    - `0.0` otherwise.
  - If the task only has a date (`hasTime = false`):
    - `0.6` if the date is "Hoy" (or within the next 24 hours). It remains at `0.6` all day and does not scale to `1.0` to prevent cognitive fatigue and late-night panic.
    - `0.0` otherwise.
- **subtasksCount**: Integer representing the number of subtasks.
- **estimatedMinutes**: Integer representing the estimated effort in minutes.
- **ageDays**: Float representing the number of days since the task was created.
- **manualBoost**: Float, default `5`. Used for manual pinning or boosting.

### Rules
1. **Automatic Projects**: If `estimatedMinutes > 120` OR `subtasksCount > 10`, the task is automatically marked as `isProject = true`.
