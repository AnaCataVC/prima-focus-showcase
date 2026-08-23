# Database Synchronization & Backend Alternatives for Prima-Focus

> **Created:** 2026-08-23  
> **Last Updated:** 2026-08-23  

## 1. Executive Summary & Context

Prima-Focus is currently a **100% Local-First Native Android application** utilizing SQLite via **Room Database**, with peer-to-peer sync via Google Nearby Connections and JSON Backup/Restore via the Android Storage Access Framework (SAF).

This document evaluates the viability, benefits, trade-offs, and implementation complexity of integrating an external database or synchronization layer—specifically examining user-owned/decentralized storage (e.g., **5apps / remoteStorage**), local-first sync engines (**PowerSync**, **ElectricSQL**), lightweight self-hosted backends (**PocketBase**), and full Backend-as-a-Service (**Supabase**, **Firebase**).

---

## 2. Alternatives Evaluated

### Option A: 5apps / remoteStorage (User-Owned Decentralized Storage)
- **Concept:** remoteStorage is an open protocol (IETF draft) enabling users to connect their own storage provider (e.g., 5apps.com, ownCloud, Nextcloud, or self-hosted Armadietto) to applications.
- **How it works:** WebDAV/REST-based key-value/document store with OAuth2 token authorization (`user@provider.com`).
- **Pros:**
  - **Zero Server Infrastructure / Zero Maintenance Cost:** Developers host no databases; users pay or host their own storage.
  - **Extreme Privacy:** Meets the local-first ethos; developer has zero access to user task data.
- **Cons:**
  - **No First-Class Android/Kotlin SDK:** remoteStorage is heavily tailored for browser JavaScript (`remotestorage.js`). Implementing it in Kotlin requires custom HTTP/WebDAV/OAuth integration.
  - **High User Friction:** Casual mobile users do not possess or understand remoteStorage/5apps accounts.
  - **No Relational Querying:** Acts as a file/blob/document store, meaning complex relational syncing or partial updates require heavy client-side reconciliation.

---

### Option B: PowerSync + PostgreSQL / Supabase (Local-First SQLite Sync Engine)
- **Concept:** PowerSync is a specialized sync layer designed specifically for offline-first apps with SQLite/Room.
- **How it works:** Room writes locally; PowerSync intercepts operations via a bundled SQLite extension (`androidx.sqlite:sqlite-bundled` + `com.powersync:integration-room`) and synchronizes client SQLite with backend Postgres/Supabase tables.
- **Pros:**
  - **Preserves Native Room DAOs & Flows:** Keeps all existing Kotlin Room queries, entities, and UI reactivity.
  - **Automatic Conflict Resolution & Offline Queuing:** Built-in sync engine handles network interruptions, background sync, and data streams.
  - **Production-Ready Kotlin SDK:** Dedicated official Room integration.
- **Cons:**
  - **Requires Backend Infrastructure:** Requires hosting or managing a PostgreSQL/Supabase instance and PowerSync cloud/self-hosted service.
  - **Tier Limits / Hosting Costs:** If hosted for public users, introduces recurring server costs.

---

### Option C: PocketBase (Lightweight Self-Hosted SQLite / Go Backend)
- **Concept:** A single-file executable written in Go combining SQLite, realtime subscriptions (SSE), auth, and REST APIs.
- **Pros:**
  - **Ultra-lightweight:** Can run on a $3-5/month VPS or fly.io.
  - **Simple Data Model:** Relational tables and user authentication out of the box.
  - **Good Community Kotlin Support (`pocketbase-kotlin`).**
- **Cons:**
  - **Not Native Local-First:** Room remains the local store, so a custom sync layer (dirty flags, timestamp comparisons, conflict resolution) must be maintained in the Android client.
  - **Centralized Infrastructure:** The developer is responsible for hosting, uptime, backups, and security patches.

---

### Option D: Supabase (`supabase-kt`)
- **Concept:** Open-source Firebase alternative based on PostgreSQL with PostgREST, Auth, and Realtime WebSocket support.
- **Pros:**
  - **Robust Ecosystem & Row Level Security (RLS).**
  - **Active Kotlin Multiplatform SDK (`supabase-community/supabase-kt`).**
  - **Rich Feature Set:** Handles user accounts, social login, cloud backups, and future web/desktop clients.
- **Cons:**
  - **Manual Local Sync Queue Required:** Similar to PocketBase, without a local-first bridge like PowerSync, manual queueing and sync logic in Room/WorkManager is needed.

---

### Option E: User-Owned Cloud Drive Sync (Google Drive AppData / Nextcloud WebDAV)
- **Concept:** Use Google Drive's hidden `appDataFolder` or user-configured Nextcloud/WebDAV endpoints to store encrypted SQLite/JSON sync snapshots.
- **Pros:**
  - **Zero Developer Backend Costs:** Uses the user's existing Google Drive or Nextcloud.
  - **Low User Friction on Android:** Almost all Android users have Google Play Services and a Google account.
  - **High Privacy:** Data remains in the user's private Google Drive storage.
- **Cons:**
  - **File/Snapshot Sync, Not Row-Level Realtime:** Ideal for cross-device backup and async synchronization, but not instant sub-second collaborative editing.

---

## 3. Comparison Matrix

| Criteria | Current (Room + P2P Nearby) | 5apps / remoteStorage | PowerSync + Supabase | PocketBase (Self-hosted) | Google Drive AppData |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Hosting Cost** | $0 (Zero) | $0 (Zero) | Free tier / Paid scaling | $3-5/mo VPS | $0 (Zero) |
| **Privacy / Ownership** | 100% User Device | User-owned Cloud | Developer Centralized | Developer Centralized | User's Cloud Account |
| **Android Integration** | Native Room | High complexity (Custom REST) | High Native (Room 3 + Bundled Driver) | Medium (HTTP/SSE) | Native Google Play Services |
| **Offline-First Support** | Native | Manual File Sync | Native Row-Level Sync | Manual Sync Queue | Snapshot Sync |
| **User Setup Friction** | None | High (Requires 5apps/remoteStorage ID) | Low (Google/Email Login) | Low (Email Login) | Transparent (Google Account) |
| **Maintenance Burden** | Zero backend | Zero backend | Low (Managed) / Med (Self-hosted) | Medium | Low |

---

## 4. Tech Lead Recommendation

1. **Keep Room as the Source of Truth:** Prima-Focus's core value proposition is instantaneous responsiveness, privacy, and zero latency for task management and Pomodoro timers. Room should never be replaced by a remote-only database.
2. **Short-Term Recommendation (Decentralized / Zero-Cost):** 
   - Expand the current SAF (Storage Access Framework) backup into automated silent syncing via **Google Drive `appDataFolder`** or **WebDAV (Nextcloud)**. This gives the exact benefit of 5apps/remoteStorage (user owns their data, zero developer cloud bill) but with native Android UX.
3. **Long-Term Multi-Device Cloud Recommendation (If Realtime Web/Desktop Sync is added):**
   - Adopt **PowerSync with Supabase / PostgreSQL**, as it natively hooks directly into Room via `com.powersync:integration-room`, avoiding the fragile manual sync queue and dirty-flag tracking.
