// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TrackChangesPrimitive",
    platforms: [
        .macOS(.v15),
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
