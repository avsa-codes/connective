# Mobile Navigation & Architecture

## 1. Stack Navigation vs. Tab Navigation

| Feature | Stack Navigation | Tab Navigation |
| :--- | :--- | :--- |
| **Model** | Deck of cards (LIFO: Push / Pop). | Dashboard with parallel sections. |
| **Flow** | Hierarchical / Linear (e.g., Feed → Details → Purchase). | Peer switching (e.g., Home, Search, Profile). |
| **State** | Preserves linear history; removes screen on back action. | Maintains independent state tree for each tab. |

---

## 2. Role of a Root Layout

The **Root Layout** acts as the top-level skeleton of the app. Its primary roles are:
* **Global Providers:** Wraps the entire application with Context Providers (Auth, Theme, State).
* **Navigation Entry:** Mounts the primary top-level navigator.
* **Initialization:** Handles splash screen visibility, font loading, and initial auth checks.
* **Error Handling:** Provides top-level error boundaries to prevent app-wide crashes.

---

## 3. Why Theme Provider Must Wrap the Navigator

* **Context Downward Flow:** React Context only passes data down to child components. 
* **Styling Navigator UI:** The navigator renders UI elements like headers, tab bars, and icons. Placing `ThemeProvider` *above* the navigator ensures these built-in navigation components have access to theme colors and tokens.
* **Unified Theme Switching:** Guarantees simultaneous theme updates (Light/Dark mode) across both the navigation bar and the screen contents.