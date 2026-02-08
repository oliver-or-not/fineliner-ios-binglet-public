// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PrimeEvent",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PrimeEvent",
            targets: [
                "PrimeEvent"
            ]),
    ],
    dependencies: [
        .package(path: "../Universe"),
        .package(path: "../Spectrum"),
        .package(path: "../Director"),
        .package(path: "../Agent"),
        .package(path: "../Plate"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PrimeEventBase",
            dependencies: [
                "Spectrum",
                "Agent",
            ],
            path: "Sources/PrimeEventBase"
        ),
        .target(
            name: "EachPrimeEvent",
            dependencies: [
                "PrimeEventBase",
                "Universe",
                "Spectrum",
                "Director",
                "Agent",
                "Plate",
            ],
            path: "Sources/EachPrimeEvent"
        ),
        .target(
            name: "PrimeEvent",
            dependencies: [
                "PrimeEventBase",
                "EachPrimeEvent",
            ],
            path: "Sources/PrimeEvent"
        ),
    ]
)
