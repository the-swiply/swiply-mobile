// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Likes",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Likes",
            targets: ["Likes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.9.2"),
        .package(path: "../SYVisualKit"),
        .package(path: "../Networking")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Likes",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "SYVisualKit",
                "Networking"
            ],
            resources: [.process("Resources/Assets.xcassets")]
        ),
        .testTarget(
            name: "LikesTests",
            dependencies: ["Likes"]),
    ]
)
