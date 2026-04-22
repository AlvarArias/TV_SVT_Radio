# TV_SVT_Radio — CLAUDE.md

## Project Overview

SwiftUI radio/TV streaming app for SVT (Swedish Television) channels.

| Component | Type | Purpose |
|-----------|------|---------|
| `Views/` | SwiftUI | Main UI components (MainView, PlayerView, etc.) |
| `Models/` | Data | Radio/TV station models, JSON parsing, playback |
| `Networking/` | API | APIClient and endpoint definitions for SVT API |
| `ViewControllers/` | Logic | ViewModels (MainViewModel, PlayerViewModel) |
| `Utils/` | Helpers | Extensions and utility functions |

**Frameworks:** SwiftUI, Combine, AVFoundation (audio playback)  
**iOS Target:** 14+  
**Current Swift version:** 5.0 → migrating to **Swift 6**  
**Key Dependencies:** Lottie (animations)

---

## Swift 6 Migration — Priority Issues

These must be fixed to enable Swift 6 strict concurrency (`SWIFT_STRICT_CONCURRENCY = complete`):

### 1. Replace deprecated APIs
```swift
// BEFORE (deprecated iOS 16)
@Environment(\.presentationMode) var presentationMode
presentationMode.wrappedValue.dismiss()

// AFTER
@Environment(\.dismiss) var dismiss
dismiss()
```

### 2. Replace DispatchQueue with async/await
```swift
// BEFORE
DispatchQueue.main.async { 
    self.isPlaying = true
}

// AFTER
await MainActor.run { 
    self.isPlaying = true
}
// or annotate the function with @MainActor
```

### 3. Add @MainActor to ViewModels
All SwiftUI Views and ObservableObject view models must be annotated:
```swift
@MainActor
class PlayerViewModel: ObservableObject { 
    @Published var isPlaying = false
    @Published var currentStation: RadioStation?
}

@MainActor
struct MainView: View { ... }
```

### 4. Networking — async/await for API calls
```swift
// BEFORE
func fetchStations(completion: @escaping ([RadioStation]?) -> Void) {
    // URLSession with callbacks
}

// AFTER
func fetchStations() async throws -> [RadioStation] {
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([RadioStation].self, from: data)
}
```

### 5. AVAudioEngine — ensure main thread for UI updates
```swift
// Wrap audio state updates in MainActor
@MainActor
func updatePlaybackState() { ... }
```

---

## Refactoring Goals

### Code Organization
- Separate `MainView` into smaller, focused components (StationListView, PlayerControlsView)
- Consolidate ViewModels: ensure clear separation between `MainViewModel` (list logic) and `PlayerViewModel` (playback)
- Move API endpoint definitions into `Endpoints.swift` — avoid hardcoded URLs
- Organize model files: group related models (RadioStation, PlayRadio, etc.) and remove unused models
- Eliminate magic strings/numbers — move all constants to `Utils/Constants.swift` or `Constants.swift`
- Add error handling for network failures and missing JSON files

### Architecture Pattern
- Use `@Observable` (iOS 17+) or `ObservableObject` consistently across ViewModels
- Prefer value types (`struct`) for RadioStation, RadioStationInfo, etc.
- Keep data flow unidirectional: Model → ViewModel → View
- APIClient should be a singleton or injected via environment
- Separate UI state from domain models (e.g., `PlayerUIState` ≠ `RadioStation`)

### Naming Conventions (enforce in Swift 6 migration)
- Types: `UpperCamelCase` (`PlayerViewModel`, `RadioStation`)
- Properties/functions: `lowerCamelCase` (`currentStation`, `playStation()`)
- Files: match the primary type they contain (`PlayerViewModel.swift`, `RadioStation.swift`)
- Prefix test files with the view they test (`MainViewTests.swift`)

---

## Development Guidelines

### General Rules
- Prefer `async/await` + structured concurrency over GCD (`DispatchQueue`)
- Never force-unwrap (`!`) unless the invariant is provably safe — add a comment explaining why
- Use `guard let` early-exit over deeply nested `if let`
- Keep views dumb: no business logic in View structs — move to ViewModel
- Do not use `AnyView` — use generics or `@ViewBuilder` instead
- Handle network errors gracefully: show UI feedback, not silent failures

### Swift 6 Specific
- Enable strict concurrency warnings in Xcode: `Build Settings → SWIFT_STRICT_CONCURRENCY = targeted`
- Resolve all `Sendable` and `@MainActor` warnings before bumping `SWIFT_VERSION` to `6`
- All API calls must be in `async` functions, never in View `.onAppear` directly
- Playback state (isPlaying, currentTime) must be `@Published` in ViewModels

### SwiftUI Patterns for Radio App
```swift
// Inject APIClient and ViewModels via environment
.environment(apiClient)
.environmentObject(playerViewModel)

// Use @StateObject for owned view models
@StateObject private var playerViewModel = PlayerViewModel()

// Extract repeated UI code into sub-views
private var playerControls: some View { ... }
private var stationList: some View { ... }

// Handle streaming errors at the View level
.alert("Playback Error", isPresented: $playerViewModel.showError) { ... }
```

---

## File Reference Map

```
TV_SVT_Radio/
├── Views/
│   ├── MainView.swift              ← Main station list & player UI
│   └── buttonFeedback.swift        ← Custom button component
├── Models/
│   ├── radioStationInfo.swift      ← RadioStation data model
│   ├── PlayRadio.swift             ← Playback logic
│   ├── LoadRadioStationJSONFile.swift ← JSON parsing for radios23.json
│   └── radios23.json               ← Station data source
├── Networking/
│   ├── APIClient.swift             ← Network requests (needs async/await)
│   └── Endpoints.swift             ← API endpoint definitions
├── ViewControllers/ (rename to ViewModels?)
│   ├── MainViewModel.swift         ← List state management
│   ├── PlayerViewModel.swift       ← Playback state (@MainActor needed)
│   └── RadioStation.swift          ← (Duplicate of radioStationInfo? Review)
└── Utils/
    ├── Extensions.swift            ← SwiftUI/Foundation extensions
    └── Helpers.swift               ← Utility functions
```

---

## Known Issues (fix during migration)

| File | Issue | Priority | Fix |
|------|-------|----------|-----|
| `APIClient.swift` | Uses callback closures instead of async/await | HIGH | Convert to async/await functions |
| `PlayerViewModel.swift` | May use `DispatchQueue.main.async` | HIGH | Add `@MainActor` + use `await` |
| `MainViewModel.swift` | No `@MainActor` annotation | HIGH | Add `@MainActor` to class |
| `MainView.swift` | May use `@Environment(\.presentationMode)` | MEDIUM | Replace with `\.dismiss` |
| `LoadRadioStationJSONFile.swift` | JSON decoding error handling | MEDIUM | Add proper error handling + logging |
| `PlayRadio.swift` | AVAudioEngine state updates | MEDIUM | Ensure UI updates on MainActor |
| `RadioStation.swift` vs `radioStationInfo.swift` | Possible duplicate models | MEDIUM | Consolidate into single model |
| Various files | Missing null-safety checks | LOW | Replace optional defaults with proper error handling |

---

## Migration Order (recommended)

### Phase 1: Preparation
1. Review & consolidate duplicate models (`RadioStation.swift` vs `radioStationInfo.swift`)
2. Move all hardcoded constants to `Utils/Constants.swift`
3. Rename `ViewControllers/` folder to `ViewModels/` for clarity

### Phase 2: Networking Layer
1. Convert `APIClient.swift` callbacks to async/await
2. Update `Endpoints.swift` with proper URL construction
3. Add comprehensive error handling + logging

### Phase 3: ViewModel Layer
1. Add `@MainActor` to `MainViewModel` and `PlayerViewModel`
2. Replace all `DispatchQueue.main.async` with `await` or `@MainActor` methods
3. Update published properties for Swift 6 Sendable compliance

### Phase 4: View Layer
1. Update deprecated API calls (`.navigationBarTitle`, `@Environment(\.presentationMode)`)
2. Split large views into smaller components
3. Ensure all view-model integration uses proper environment/state patterns

### Phase 5: Enable Strict Concurrency
1. Set `SWIFT_STRICT_CONCURRENCY = targeted` in Build Settings
2. Fix all warnings in sequence
3. Set `SWIFT_STRICT_CONCURRENCY = complete`
4. Bump `SWIFT_VERSION = 6` and test thoroughly
