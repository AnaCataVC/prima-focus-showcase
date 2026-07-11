-- Initial version: schema_version = 1 (Local Room Database)

CREATE TABLE IF NOT EXISTS tasks (
  taskId TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  subcategory TEXT,
  categoryWeight REAL NOT NULL,
  date TEXT,                 -- YYYY-MM-DD or NULL
  time TEXT,                 -- HH:MM or NULL
  hasTime INTEGER NOT NULL DEFAULT 0, -- 0/1
  timeUrgency REAL DEFAULT 0.0,
  estimatedMinutes INTEGER,
  subtasksCount INTEGER DEFAULT 0,
  isProject INTEGER NOT NULL DEFAULT 0, -- 0/1
  recurrence TEXT,           -- RFC5545 string or NULL
  manualBoost REAL DEFAULT 0.0,
  nonPostponable INTEGER NOT NULL DEFAULT 0, -- 0/1
  priorityScore REAL DEFAULT 0.0,
  status TEXT NOT NULL DEFAULT 'pending', -- pending|in_progress|completed|archived
  posponedReason TEXT,
  createdAt INTEGER NOT NULL, -- epoch ms
  updatedAt INTEGER NOT NULL, -- epoch ms
  meta TEXT
);

CREATE INDEX IF NOT EXISTS idx_tasks_today_candidate ON tasks(date, status, priorityScore DESC);
CREATE INDEX IF NOT EXISTS idx_tasks_updatedAt ON tasks(updatedAt);

CREATE TABLE IF NOT EXISTS sessions (
  sessionId TEXT PRIMARY KEY,
  taskId TEXT,
  startAt INTEGER NOT NULL,
  endAt INTEGER,
  mode TEXT,
  durationMinutes INTEGER,
  result TEXT,
  feeling INTEGER,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL,
  FOREIGN KEY(taskId) REFERENCES tasks(taskId) ON DELETE SET NULL
);

CREATE INDEX IF NOT EXISTS idx_sessions_taskId ON sessions(taskId);

CREATE TABLE IF NOT EXISTS events (
  eventId TEXT PRIMARY KEY,
  taskId TEXT,
  type TEXT,
  scheduledAt INTEGER,
  attempt INTEGER DEFAULT 0,
  action TEXT,
  status TEXT,
  createdAt INTEGER NOT NULL,
  updatedAt INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS analytics (
  eventId TEXT PRIMARY KEY,
  eventType TEXT,
  payload TEXT,
  createdAt INTEGER NOT NULL
);
