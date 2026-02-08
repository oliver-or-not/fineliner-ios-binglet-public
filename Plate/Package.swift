// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Plate",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Plate",
            targets: [
                "Plate",
            ]
        ),
    ],
    dependencies: [
        .package(path: "../Universe"),
        .package(path: "../Spectrum"),
        .package(path: "../Director"),
        .package(path: "../Agent"),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
                .upToNextMajor(from: "12.10.0")
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PlateBase",
            dependencies: [
                "Spectrum",
            ],
            path: "Sources/PlateBase",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "EachPlate",
            dependencies: [
                "Universe",
                "Spectrum",
                "Director",
                "Agent",
                "PlateBase",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: "Sources/EachPlate",
        ),
        .target(
            name: "Plate",
            dependencies: [
                "PlateBase",
                "EachPlate",
            ],
            path: "Sources/Plate"
        ),
    ]
)
