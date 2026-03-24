// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ChineseLearning",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .iOSApplication(
            name: "ChineseLearning",
            targets: ["ChineseLearning"],
            bundleIdentifier: "com.example.chineselearning",
            teamIdentifier: "",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .book),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeLeft,
                .landscapeRight
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "ChineseLearning",
            path: "Sources",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
