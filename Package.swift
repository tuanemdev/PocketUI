// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "PocketUI",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "PocketUI",
            targets: ["PocketUI"]
        ),
    ],
    targets: [
        .target(
            name: "PocketUI"
        ),
        .testTarget(
            name: "PocketUITests",
            dependencies: ["PocketUI"]
        ),
    ],
)
