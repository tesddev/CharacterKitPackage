// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CharacterKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "CharacterKit",
            targets: ["CharacterKit"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CharacterKit",
            dependencies: []),
        .testTarget(
            name: "CharacterKitTests",
            dependencies: ["CharacterKit"]),
    ]
)
