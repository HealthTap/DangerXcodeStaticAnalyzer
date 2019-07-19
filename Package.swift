// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "DangerXcodeStaticAnalyzer",
    products: [
        .library(
            name: "DangerXcodeStaticAnalyzer",
            targets: ["DangerXcodeStaticAnalyzer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "DangerXcodeStaticAnalyzer",
            dependencies: ["Danger"]),
    ]
)
