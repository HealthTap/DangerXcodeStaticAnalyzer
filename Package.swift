// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DangerXcodeStaticAnalyzer",
    products: [
        .library(
            name: "DangerXcodeStaticAnalyzer",
            targets: ["DangerXcodeStaticAnalyzer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "2.0"),
    ],
    targets: [
        .target(
            name: "DangerXcodeStaticAnalyzer",
            dependencies: ["Danger"]),
    ]
)
