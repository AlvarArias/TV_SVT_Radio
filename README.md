# TV_SVT_Radio

![CI](https://github.com/AlvarArias/TV_SVT_Radio/actions/workflows/ci.yml/badge.svg)
![Codecov](https://codecov.io/gh/AlvarArias/TV_SVT_Radio/branch/main/graph/badge.svg)

TV_SVT_Radio es una aplicación iOS escrita en Swift para reproducir streams de radio de SVT. Este repositorio contiene la app, tests y flujo de CI sugerido para ejecutar los tests con GitHub Actions.

Características rápidas:

- Reproducción de stream de radio (AVFoundation)
- Visualización de metadata (título, programa, carátula)
- Reproducción en segundo plano y controles de reproducción

Cómo ejecutar

1. Abrir el proyecto en Xcode (TV_SVT_Radio.xcodeproj o .xcworkspace).
2. Seleccionar el scheme adecuado y un simulador.
3. Ejecutar Product → Test (Cmd+U) para correr los tests.

Desde la línea de comandos (ejemplo):

xcodebuild -workspace "TV_SVT_Radio.xcworkspace" -scheme "TV_SVT_Radio" -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 14' test

Añadir CI

Se incluye un workflow sugerido (.github/workflows/ci.yml en la rama testing) que ejecuta los tests en runners macOS y detecta CocoaPods/SwiftPM.

Contribuir

- Abre issues para bugs o mejoras.
- Usa la rama testing para cambios relacionados con tests y CI.

Licencia

Añade aquí la licencia que prefieras (p.ej. MIT).