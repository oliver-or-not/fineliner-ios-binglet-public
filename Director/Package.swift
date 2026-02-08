// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Director",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Director",
            targets: [
                "Director",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Universe"),
        .package(path: "../Spectrum"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DirectorBase",
            dependencies: [
                "Spectrum",
            ],
            path: "Sources/DirectorBase"
        ),
        .target(
            name: "EachDirector",
            dependencies: [
                "Universe",
                "Spectrum",
                "DirectorBase",
            ],
            path: "Sources/EachDirector",
        ),
        .target(
            name: "Director",
            dependencies: [
                "DirectorBase",
                "EachDirector",
            ],
            path: "Sources/Director"
        ),
    ]
)
