// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spectrum",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Spectrum",
            targets: [
                "Spectrum",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Universe"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Designation",
            path: "Sources/Designation"
        ),
        .target(
            name: "DesignSystem",
            dependencies: [
                "Universe",
            ],
            path: "Sources/DesignSystem",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "GlobalEntityTree",
            dependencies: [
                "Universe",
            ],
            path: "Sources/GlobalEntityTree"
        ),
        .target(
            name: "Policy",
            dependencies: [
                "Universe",
            ],
            path: "Sources/Policy"
        ),
        .target(
            name: "PureDataType",
            dependencies: [
                "Universe",
            ],
            path: "Sources/PureDataType"
        ),
        .target(
            name: "Spectrum",
            dependencies: [
                "Universe",
                "Designation",
                "DesignSystem",
                "GlobalEntityTree",
                "Policy",
                "PureDataType",
            ],
            path: "Sources/Spectrum"
        ),
    ]
)
