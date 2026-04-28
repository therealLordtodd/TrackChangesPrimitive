// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TrackChangesPrimitive",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "TrackChangesPrimitive", targets: ["TrackChangesPrimitive"]),
    ],
    targets: [
        .target(name: "TrackChangesPrimitive"),
        .testTarget(
            name: "TrackChangesPrimitiveTests",
            dependencies: ["TrackChangesPrimitive"]
        ),
    ]
)
