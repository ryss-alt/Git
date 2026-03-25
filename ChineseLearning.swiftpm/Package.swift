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
            targets: ["ChineseLearning"]
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
