-- ============================================================================
-- Prima-Focus Database Schema (Room v6 / SQLite Production Schema)
-- Local-First Architecture with Soft Deletes, Version-Aware LWW & Clock Drift Resilience
-- ============================================================================

-- ----------------------------------------------------------------------------
-- Table: tasks
-- Core entity representing individual action items and projects.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tasks (
  taskId TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  subcategory TEXT,
  categoryWeight REAL NOT NULL,
  date TEXT,                              -- YYYY-MM-DD or NULL
  time TEXT,                              -- HH:MM or NULL
  hasTime INTEGER NOT NULL DEFAULT 0,     -- Boolean: 0/1
  timeUrgency REAL NOT NULL DEFAULT 0.0,
  estimatedMinutes INTEGER,
  isProject INTEGER NOT NULL DEFAULT 0,   -- Boolean: 0/1
  recurrence TEXT,                        -- RFC5545 or recurrence rule (DAILY, WEEKLY:MO,WE,FR, etc.)
  recurrenceGroupId TEXT DEFAULT NULL,    -- Groups all instances of the same recurring series
  manualBoost REAL NOT NULL DEFAULT 0.0,
  nonPostponable INTEGER NOT NULL DEFAULT 0, -- Boolean: 0/1
  priorityScore REAL NOT NULL DEFAULT 0.0,
  status TEXT NOT NULL DEFAULT 'pending', -- pending | in_progress | completed | archived
  postponedReason TEXT,
  createdAt INTEGER NOT NULL,             -- Epoch ms
  updatedAt INTEGER NOT NULL,             -- Epoch ms (LWW secondary comparison)
  meta TEXT,
  isDeleted INTEGER NOT NULL DEFAULT 0,   -- Soft delete tombstone for P2P/LAN sync (0 = active, 1 = deleted)
  deletedAt INTEGER DEFAULT NULL,         -- Epoch ms when soft-deleted (used for 30-day GC purge)
  syncVersion INTEGER NOT NULL DEFAULT 1  -- Incremental version counter for clock-drift resilience
);

CREATE INDEX IF NOT EXISTS idx_tasks_today_candidate ON tasks(date, status, priorityScore DESC);
CREATE INDEX IF NOT EXISTS idx_tasks_updatedAt ON tasks(updatedAt);

-- ----------------------------------------------------------------------------
-- Table: sessions
-- Focus and Pomodoro session logs linked to tasks.
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sessions (
  sessionId TEXT PRIMARY KEY,
  taskId TEXT,
  startAt INTEGER NOT NULL,               -- Epoch ms start timestamp
  endAt INTEGER,                          -- Epoch ms completion timestamp or NULL
  mode TEXT,                              -- Focus mode identifier (e.g. POMODORO, SHORT_BREAK, LONG_BREAK)
  result TEXT,                            -- Completed status or early cancellation reason
  feeling INTEGER,                        -- Subjective satisfaction score (1 to 5)
  createdAt INTEGER NOT NULL,             -- Epoch ms
  updatedAt INTEGER NOT NULL,             -- Epoch ms
  isDeleted INTEGER NOT NULL DEFAULT 0,   -- Soft delete tombstone for P2P/LAN sync
  deletedAt INTEGER DEFAULT NULL,         -- Epoch ms when soft-deleted (used for 30-day GC purge)
  syncVersion INTEGER NOT NULL DEFAULT 1, -- Incremental version counter for clock-drift resilience
  FOREIGN KEY(taskId) REFERENCES tasks(taskId) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_sessions_taskId ON sessions(taskId);

-- ----------------------------------------------------------------------------
-- Deprecated / Dropped Tables in Room v6:
-- - events: Dropped in Room v6 via MIGRATION_5_6 (DROP TABLE IF EXISTS events).
-- ----------------------------------------------------------------------------

-- ============================================================================
-- Room Migration History:
-- - MIGRATION_1_2: Added recurrenceGroupId column to tasks.
-- - MIGRATION_2_3: Recreated tasks table to drop deprecated subtasksCount column.
-- - MIGRATION_3_4: Recreated sessions table to drop durationMinutes column.
-- - MIGRATION_4_5: Added isDeleted, deletedAt, and syncVersion to tasks & sessions for P2P sync.
-- - MIGRATION_5_6: Dropped unused legacy events table (DROP TABLE IF EXISTS events).
-- ============================================================================
