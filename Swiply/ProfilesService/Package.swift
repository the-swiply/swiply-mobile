// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProfilesService",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ProfilesService",
            targets: ["ProfilesService"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.2"),
        .package(path: "../Networking"),
        .package(path: "../SYCore")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProfilesService",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Networking",
                "SYCore"
            ],
            resources: [.process("Resources/Assets.xcassets")]
        ),
        .testTarget(
            name: "ProfilesServiceTests",
            dependencies: ["ProfilesService"]),
    ]
)
