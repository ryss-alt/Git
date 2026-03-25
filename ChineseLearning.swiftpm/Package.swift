// swift-tools-version: 5.9
import PackageDescription
import AppleProductTypes

let package = Package(
    name: "ChineseLearning",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .iOSApplication(
            name: "ChineseLearning",
            targets: ["ChineseLearning"],
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft
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
