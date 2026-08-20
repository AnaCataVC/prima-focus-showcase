# AGENTS.md — AI Agent Guidelines & Architecture Manual

This document serves as the operational manual, architecture reference, and workflow guide for AI coding agents operating within the **Prima Focus Showcase** repository.

---

## 1. Project Overview & Architecture

**Prima Focus Showcase** is the official public landing page and download portal for the **Prima Focus** Android application. It provides interactive feature breakdowns, screenshots, release history, and direct APK download links.

### Tech Stack:
- **Markup & Layout**: Semantic HTML5, Vanilla JavaScript for interactive tabs and modals.
- **Styling**: Tailwind CSS CLI (custom pastel palette, responsive breakpoints, dark/light styling).
- **Hosting & Deployment**: Vercel / GitHub Pages (Static site).
- **Public Artifacts (`apk/`)**: Signed release APKs of the Prima Focus Android application for direct download.

---

## 2. Directory Structure

```text
prima-focus-showcase/
├── index.html                 # Main landing page markup and interactive logic
├── src/
│   └── input.css              # Tailwind CSS entrypoint with custom utility directives
├── dist/
│   └── output.css             # Minified, compiled CSS (generated via Tailwind CLI)
├── apk/                       # Downloadable signed APK releases (e.g., prima-focus-v1.3.0.apk)
├── assets/                    # Screenshots, logos, mockup graphics, and icons
├── docs/                      # Synchronized architecture & technical documentation from app
├── tailwind.config.js         # Tailwind configuration and theme tokens
├── package.json               # Build scripts & Tailwind CLI dependency
└── README.md                  # Bilingual project documentation (EN/ES)
```

---

## 3. Mandatory Agent Rules & Directives

### 🌐 Language & Communication
- **Source Code**: HTML structure, JavaScript functions, CSS classes, and comments MUST be in **English**.
- **User Chat**: Interact with the user in **Spanish** unless explicitly requested otherwise.
- **Git Commits**: Use **Conventional Commits** in **English** (e.g., `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`).
- **README**: Maintain bilingual documentation (English and Spanish).

### 🔒 Security & Privacy
- **Source Code Protection**: This showcase is a public repository. NEVER copy private Android source code (`/app/src`) from the private app repository. Only copy public release APKs, docs, and assets.
- **Path Privacy**: NEVER leak local computer paths (e.g., `C:\Users\...`) into HTML, markdown files, or commit logs. Use relative links (`apk/prima-focus-vX.Y.Z.apk`).

### 💻 PowerShell Environment
- **Command Chaining**: NEVER use `&&` or `||` in terminal commands. Use `;` or sequential commands.
- **GitHub CLI Context**: Switch to personal account `AnaCataVC` (`gh auth switch -u AnaCataVC --hostname github.com 2>$null`).

---

## 4. Development & Build Commands (PowerShell)

### Tailwind CSS Compilation
```powershell
# Watch mode for local development
npm run dev

# Minified production build
npm run build:css
```

---

## 5. UI Verification & Browser Caching Guidelines

> [!IMPORTANT]
> **Vanilla HTML & CSS Caching**:
> When testing UI changes locally after running `npm run build:css`:
> 1. Open the file directly using the `file:///` protocol in your browser (e.g. `file:///path/to/index.html`) to bypass aggressive HTTP caching.
> 2. If viewing via local HTTP server (`localhost`), perform a **Hard Refresh** (`Ctrl+F5` / `Cmd+Shift+R`) to ensure `dist/output.css` updates are loaded.

---

## 6. Release & Showcase Synchronization Protocol

Whenever a new version of the Prima Focus Android app is compiled:
1. Copy the signed release APK into `apk/` with semantic naming (e.g. `apk/prima-focus-vX.Y.Z.apk`).
2. Update the version badges, download button links, and changelog section in `index.html`.
3. Synchronize any updated architecture documentation into `docs/`.
4. Run `npm run build:css` to ensure all CSS styles are compiled before committing.
