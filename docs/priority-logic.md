# Priority Logic

The core value of Prima-Focus is its deterministic and reproducible task prioritization formula.

## The Formula

The Priority Score is calculated by splitting the factors into a **Base Score** (static importance) and a **Dynamic Urgency** component:

`priorityScore = baseScore + dynamicUrgency + manualBoost`

### 1. Base Score (Static component)
`baseScoreStatic = max(0.0, 10 * categoryWeight - 0.5 * ageDays)`

- **High Priority Floor (Rule)**: If `categoryWeight >= 4.0`, the base score is clamped to a minimum of `70.0`:
  `baseScore = max(70.0, baseScoreStatic)`
  Otherwise:
  `baseScore = baseScoreStatic`

### 2. Dynamic Urgency (Calendar & Scheduling component)
`dynamicUrgency` is calculated based on strict calendar day hierarchy:
- **Overdue**: `14.0` points (+6 date + 8 overdue).
- **Scheduled for Today ("Hoy")**:
  - If specific time is set: `6.0 + 8.0 * timeUrgency` (up to `14.0` if within 2 hours or overdue).
  - If no specific time: `10.8` points (`6.0 + 8.0 * 0.6`).
- **Scheduled for Tomorrow ("Mañana")**: `4.0` points (moderate visibility without competing with today).
- **Future Scheduled Date**: `2.0` points.
- **Unscheduled Backlog**: `0.0` points.

### Variables
- **categoryWeight**: Float mapped from the task's category and subcategory (see `categories.md`).
- **hasDate**: Boolean (1 if true, 0 if false).
- **ageDays**: Float representing the number of days since the task was created.
- **manualBoost**: Float, default `0.0` (adjusts in increments of `+10` / `-10`). Used for manual pinning or demoting.


