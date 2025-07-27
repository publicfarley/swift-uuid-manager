// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "uuid-manager",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(
            name: "uuid-manager",
            targets: ["UUIDManager"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    ],
    targets: [
        .executableTarget(
            name: "UUIDManager",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
    ]
)