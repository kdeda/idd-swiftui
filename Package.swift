// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "idd-swiftui",
    platforms: [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "IDDSwiftUI",
            targets: ["IDDSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kdeda/idd-log4-swift.git", from: "1.2.3"),
        .package(url: "https://github.com/kdeda/idd-swift.git", from: "1.0.7")
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
