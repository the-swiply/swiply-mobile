// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Events",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Events",
            targets: ["Events"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.9.2"),
        .package(path: "../SYVisualKit"),
        .package(path: "../Networking"),
        .package(path: "../SYCore")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Events",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SYVisualKit",
                "Networking",
                "SYCore"
            ],
            resources: [.process("Resources/Assets.xcassets")]
        ),
        .testTarget(
            name: "EventsTests",
            dependencies: ["Events"]),
    ]
)
