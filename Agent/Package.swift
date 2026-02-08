// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Agent",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Agent",
            targets: [
                "Agent",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Universe"),
        .package(path: "../Spectrum"),
        .package(path: "../Director"),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
                .upToNextMajor(from: "12.10.0")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AgentBase",
            dependencies: [
                "Spectrum",
            ],
            path: "Sources/AgentBase"
        ),
        .target(
            name: "EachAgent",
            dependencies: [
                "Universe",
                "Spectrum",
                "Director",
                "AgentBase",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: "Sources/EachAgent",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "Agent",
            dependencies: [
                "AgentBase",
                "EachAgent",
            ],
            path: "Sources/Agent"
        ),
    ]
)
