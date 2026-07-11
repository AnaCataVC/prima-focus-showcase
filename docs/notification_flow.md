# Notification Flow

```mermaid
flowchart TD

    %% Main nodes
    A[TaskEngine\npriorityScore Calculation] --> B[TodayTaskSelector\nSelect Today's Task]
    B --> C[NotificationScheduler\nSchedule Notifications]
    C --> D[EventLog\nLog Events]
    D --> E[NotificationDispatcher\nDispatch Notifications]
    E --> F[RetryPolicy\nDetermine Retries]
    F --> C

    %% TaskEngine internals
    subgraph TaskEngine
        A1[categoryWeight]
        A2[hasDate]
        A3[timeUrgency]
        A4[subtasksCount]
        A5[estimatedMinutes]
        A6[ageDays]
        A7[manualBoost]
        A8[nonPostponable rules]

        A1 --> A
        A2 --> A
        A3 --> A
        A4 --> A
        A5 --> A
        A6 --> A
        A7 --> A
        A8 --> A
    end

    %% Scheduler details
    subgraph Scheduler
        C1[Score ≥ 70 → Aggressive noti]
        C2[40–69 → Standard noti]
        C3[<40 → Soft noti 09:00]
        C4[Retries based on level]
        C5[nonPostponable → no snooze]

        C1 --> C
        C2 --> C
        C3 --> C
        C4 --> C
        C5 --> C
    end

    %% Dispatcher
    subgraph Dispatcher
        E1[Start]
        E2[Snooze 1h]
        E3[Mute 1h]
        E4[nonPostponable → no snooze]

        E1 --> E
        E2 --> E
        E3 --> E
        E4 --> E
    end

    %% RetryPolicy
    subgraph Retry
        F1[Retries left?]
        F2[Task still pending?]
        F3[Score changed?]
        F4[Became nonPostponable?]

        F1 --> F
        F2 --> F
        F3 --> F
        F4 --> F
    end
```

## Defined Infrastructure
**Android**: Kotlin, Room, WorkManager, ForegroundService, NotificationManager.

## Configurable WorkManager Frequency
The app uses a `PeriodicWorkRequest` (`NotificationWorker`) mapped directly to the user's settings (via `SharedPreferences` `notification_frequency`).
- **Dynamic Rescheduling**: When the user updates the frequency from the `SettingsScreen` (e.g. 15m, 30m, 1h, 2h), the `TaskViewModel` uses `ExistingPeriodicWorkPolicy.REPLACE` to update the worker instantly.
- **Off State**: If the frequency is set to `0` or `< 0` (Apagadas), the system executes `workManager.cancelUniqueWork("NotificationWorker")`, stopping background jobs completely to respect user boundaries and battery life.
