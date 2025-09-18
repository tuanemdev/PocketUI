// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "PocketUI",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "PocketUI",
            targets: ["PocketUI"],
        ),
    ],
    targets: [
        .target(
            name: "PocketUI",
            swiftSettings: [
                .defaultIsolation(MainActor.self),
            ],
        ),
        .testTarget(
            name: "PocketUITests",
            dependencies: ["PocketUI"],
        ),
    ],
)
