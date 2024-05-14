// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SYCore",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SYCore",
            targets: ["SYCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.25.0"),
        .package(path: "../Networking")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SYCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
                "Networking"
            ]
        ),
        .testTarget(
            name: "SYCoreTests",
            dependencies: ["SYCore"]),
    ]
)

