// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CapacitorMapbox",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CapacitorMapbox",
            targets: ["CapacitorMapboxPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", branch: "main")
    ],
    targets: [
        .target(
            name: "CapacitorMapboxPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/CapacitorMapboxPlugin"),
        .testTarget(
            name: "CapacitorMapboxPluginTests",
            dependencies: ["CapacitorMapboxPlugin"],
            path: "ios/Tests/CapacitorMapboxPluginTests")
    ]
)