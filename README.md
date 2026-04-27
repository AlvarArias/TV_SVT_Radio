# TV_SVT_Radio

![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat&logo=swift)
![iOS](https://img.shields.io/badge/iOS-16+-blue?style=flat&logo=apple)
![CI](https://github.com/AlvarArias/TV_SVT_Radio/actions/workflows/ios.yml/badge.svg)
![License](https://img.shields.io/badge/license-MIT-lightgrey?style=flat)

iOS app written in Swift for streaming SVT radio and TV channels. Features background playback, metadata display, and a lightweight architecture ready for unit testing and CI with GitHub Actions.

## Features

- Stream SVT radio and TV channels in real time
- Background audio playback with lock screen controls
- Metadata display — current title and programme info
- Basic playback controls
- Unit and UI test suites
- CI/CD pipeline via GitHub Actions

## Getting Started

```bash
git clone https://github.com/AlvarArias/TV_SVT_Radio.git
cd TV_SVT_Radio
open TV_SVT_Radio.xcodeproj
```

> Requires Xcode 15+ and an iOS 16 simulator or physical device.

## Project Structure

| Folder | Description |
|--------|-------------|
| `TV_SVT_Radio/` | Main app source code |
| `TV_SVT_RadioTests/` | Unit tests |
| `TV_SVT_RadioUITests/` | UI tests |
| `.github/workflows/` | GitHub Actions CI pipelines |

## CI/CD

The project includes two GitHub Actions workflows that run on every push and pull request to `main`:

- **`ios.yml`** — builds and runs tests on the iOS Simulator
- **`swift.yml`** — resolves Swift packages and builds the scheme

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request to suggest improvements or fix bugs.

## License

This project is available under the [MIT](LICENSE) license.

---

Developed by [Alvar Arias](https://github.com/AlvarArias) · [LinkedIn](https://www.linkedin.com/in/alvararias/) · [Portfolio](https://alvararias.github.io/)