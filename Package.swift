// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DangerXcodeStaticAnalyzer",
    products: [
        .library(
            name: "DangerXcodeStaticAnalyzer",
            targets: ["DangerXcodeStaticAnalyzer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/danger-swift.git", from: "0.3.0")
    ],
    targets: [
        .target(
            name: "DangerXcodeStaticAnalyzer",
            dependencies: ["Danger"]),
        .testTarget(
            name: "DangerXcodeStaticAnalyzerTests",
            dependencies: ["DangerXcodeStaticAnalyzer"]),
    ]
)
