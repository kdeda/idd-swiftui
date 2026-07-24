// swift-tools-version:6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "idd-swiftui",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "IDDSwiftUI",
            targets: ["IDDSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kdeda/idd-log4-swift.git", "2.3.4" ..< "3.0.0"),
        // .package(name: "idd-swift", path: "../idd-swift"),
        .package(url: "https://github.com/kdeda/idd-swift.git", "2.7.3" ..< "3.0.0"),
    ],
    targets: [
        .target(
            name: "IDDSwiftUI",
            dependencies: [
                .product(name: "Log4swift", package: "idd-log4-swift"),
                .product(name: "IDDSwift", package: "idd-swift")
            ]
        ),
        .testTarget(
            name: "IDDSwiftUITests",
            dependencies: [
                .product(name: "Log4swift", package: "idd-log4-swift"),
                .product(name: "IDDSwift", package: "idd-swift")
            ]
        )
    ]
)
