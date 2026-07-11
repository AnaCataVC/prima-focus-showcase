# Learning: Clean Code and Tech Debt Resolution

## The Problem
During development, logic to calculate "Quiet Hours" and string keys for `SharedPreferences` were duplicated across multiple files (`TaskViewModel.kt` and `NotificationWorker.kt`). Additionally, some dependencies were hardcoded into `build.gradle.kts` instead of using the established Version Catalog. 

This constituted Technical Debt:
- **Duplication (Violation of DRY)**: Any change in the time-parsing logic would require identical changes in multiple places, risking desynchronization.
- **Magic Strings**: Hardcoded strings are prone to typos, causing silent failures (e.g., saving to one preference key and reading from a slightly misspelled one).

## The Solution
We performed a dedicated Tech Debt resolution pass:
1. **Extraction**: We created a `TimeUtils` object to encapsulate all mathematical and calendar logic related to time calculations.
2. **Centralization**: We created a `Constants` object to hold all SharedPreferences keys and Notification IDs.
3. **Migration**: We moved all stray dependencies into `libs.versions.toml`.

## Key Takeaway
Proactively scanning for and resolving technical debt prevents the codebase from becoming brittle. Centralizing strings and logic early on is much easier than fixing hundreds of duplicated lines later in the project's lifecycle.
