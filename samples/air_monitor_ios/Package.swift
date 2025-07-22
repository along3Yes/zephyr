// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AirMonitor",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .iOSApplication(
            name: "AirMonitor",
            targets: ["AirMonitor"],
            bundleIdentifier: "com.example.AirMonitor",
            teamIdentifier: nil,
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(),
            accentColor: .preset(.orange),
            supportedDeviceFamilies: [
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AirMonitor",
            path: "Sources",
            resources: [
                .process("Resources/Info.plist")
            ]
        )
    ]
)
