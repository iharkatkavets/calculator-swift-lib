// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MathTreeApp",
    products: [
        .executable(name: "calc", targets: ["Calculator"]),
        .executable(name: "gentool", targets: ["GenTool"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/onevcat/Rainbow", .upToNextMajor(from: "4.0.0")),
    ],
    targets: [
        .executableTarget(
            name: "Calculator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "MathTree",
                "Rainbow",
            ],
            path: "Sources/Calculator"
        ),
        .executableTarget(
            name: "GenTool",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            path: "Sources/GenTool"
        ),
        .target(
            name: "MathTree",
            path: "Sources/MathTree"
        ),
        .testTarget(
            name: "MathTreeTests",
            dependencies: ["MathTree"],
            path: "Tests/MathTreeTests"
        ),
        .testTarget(
            name: "CalculatorTests",
            dependencies: ["Calculator"],
            path: "Tests/CalculatorTests"
        ),
    ]
)
