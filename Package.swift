// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "IGRPhotoTweaks",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "IGRPhotoTweaks",
            targets: ["IGRPhotoTweaks"]
        )
    ],
    targets: [
        .target(
            name: "IGRPhotoTweaks",
            path: "IGRPhotoTweaks",
            exclude: []
        ),
        .testTarget(
            name: "IGRPhotoTweaksTests",
            dependencies: ["IGRPhotoTweaks"],
            path: "IGRPhotoTweaksTests"
        )
    ]
)
