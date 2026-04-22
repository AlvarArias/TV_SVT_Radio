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
**tvOS Target:** 26.0+ (updated from 16.4)  
**Current Swift version:** 6.0 (updated from 5.0)  
**Key Dependencies:** Lottie (animations)

---

## ✅ Swift 6 Migration — COMPLETED

### Completed Updates:
- ✅ Added `@MainActor` to all ViewModels (PlayerViewModel, MainViewModel)
- ✅ Made ViewModels `final` for optimization
- ✅ Replaced `DispatchQueue.main.async` with async/await in MainViewModel.fetchChannels()
- ✅ Updated MainView to use `.task {}` instead of `.onAppear {}` for async operations
- ✅ Fixed force unwrap in PlayRadio.swift (guard let instead of !)
- ✅ Updated build settings: tvOS deployment target to 26.0
- ✅ Updated build settings: Swift version to 6.0
- ✅ Updated naming convention: `buttonFeedback` → `ButtonFeedback` struct

---

## Swift 6 Migration Status — ✅ COMPLETE

The project has been successfully migrated to Swift 6 and tvOS 26.0. All key concurrency and deprecated API issues have been resolved:

### Changes Applied:

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

## Issues Fixed During Migration

| File | Issue | Status |
|------|-------|--------|
| `PlayerViewModel.swift` | Missing `@MainActor` annotation | ✅ FIXED |
| `MainViewModel.swift` | Used `DispatchQueue.main.async` | ✅ FIXED (now async/await) |
| `PlayRadio.swift` | Force unwrap in URL initialization | ✅ FIXED (guard let) |
| `buttonFeedback.swift` | Non-conforming struct naming | ✅ FIXED (ButtonFeedback) |
| `project.pbxproj` | tvOS deployment target 16.4 | ✅ FIXED (now 26.0) |
| `project.pbxproj` | Swift version 5.0 | ✅ FIXED (now 6.0) |
| `MainView.swift` | Using `.onAppear` for async code | ✅ FIXED (now `.task`) |

---

## Next Steps for Optimization

Now that the project has been migrated to Swift 6 and tvOS 26, consider these improvements:

### Immediate (Quality Improvements)
1. Enable `SWIFT_STRICT_CONCURRENCY = complete` in Build Settings for complete type safety
2. Consolidate duplicate models: `RadioStation.swift` vs `radioStationInfo.swift`
3. Rename folder `ViewControllers/` to `ViewModels/` for clarity
4. Add comprehensive error handling with `Result` types

### Medium-term (Architecture)
1. Implement proper API error handling in `APIClient.swift`
2. Create dedicated `UIState` models separate from domain models
3. Extract reusable UI components from MainView
4. Add unit tests for ViewModels using async/await patterns

### Long-term (Features)
1. Implement offline caching for radio stations
2. Add podcast support alongside radio
3. Implement user preferences/favorites
4. Add accessibility improvements (VoiceOver support)
