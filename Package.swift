// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SVGPathKit",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "SVGPathKit",
            targets: ["SVGPathKit"])
    ],
    targets: [
        .target(
            name: "SVGPathKit"),
        .testTarget(
            name: "SVGPathKitTests",
            dependencies: ["SVGPathKit"]
        ),
    ]
)
