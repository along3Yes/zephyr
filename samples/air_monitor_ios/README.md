# Air Monitor iOS App

This sample contains a minimal iOS application written in SwiftUI. The app connects to an air quality sensor based on an nRF52840 board and reads data over Bluetooth Low Energy.

## Setup

1. Open `Package.swift` in Xcode 14 or later. Xcode will automatically generate a project from the Swift Package.
2. Select a simulator or iOS device and build the `AirMonitor` scheme.

The app scans for peripherals advertising the custom Air Quality Service UUID `0000A001-0000-1000-8000-00805F9B34FB` and reads three characteristics:

- Temperature (UUID `0000A002-0000-1000-8000-00805F9B34FB`)
- Humidity (UUID `0000A003-0000-1000-8000-00805F9B34FB`)
- Formaldehyde (UUID `0000A004-0000-1000-8000-00805F9B34FB`)

Update the UUIDs if your firmware uses different values.
