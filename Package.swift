// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "DangerXcodeStaticAnalyzer",
    products: [
        .library(
            name: "DangerXcodeStaticAnalyzer",
            targets: ["DangerXcodeStaticAnalyzer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.0.0"),
    ],
    targets: [
        .target(
            name: "DangerXcodeStaticAnalyzer",
            dependencies: ["Danger"]),
    ]
)
