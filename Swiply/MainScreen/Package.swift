// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MainScreen",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MainScreen",
            targets: ["MainScreen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.2"),
        .package(path: "../SYVisualKit"),
        .package(path: "../Networking"),
        .package(path: "../Recommendations"),
        .package(path: "../Likes"),
        .package(path: "../Authorization"),
        .package(path: "../RandomCoffee"),
        .package(path: "../Chat"),
        .package(path: "../Profile"),
        .package(path: "../Events")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MainScreen",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SYVisualKit",
                "Networking",
                "Recommendations",
                "Likes",
                "Authorization",
                "RandomCoffee",
                "Chat",
                "Profile",
                "Events"
            ],
            resources: [.process("Resources/Assets.xcassets")]
        ),
        .testTarget(
            name: "MainScreenTests",
            dependencies: ["MainScreen"]),
    ]
)
