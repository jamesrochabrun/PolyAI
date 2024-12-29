// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PolyAI",
    platforms: [
         .iOS(.v15),
         .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PolyAI",
            targets: ["PolyAI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/jamesrochabrun/SwiftOpenAI", branch: "main"),
        .package(url: "https://github.com/jamesrochabrun/SwiftAnthropic", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PolyAI",
            dependencies: [
               .product(name: "SwiftOpenAI", package: "SwiftOpenAI"),
               .product(name: "SwiftAnthropic", package: "SwiftAnthropic"),
            ]),
        .testTarget(
            name: "PolyAITests",
            dependencies: ["PolyAI"]),
    ]
)
