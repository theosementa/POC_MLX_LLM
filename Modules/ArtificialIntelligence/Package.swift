// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ArtificialIntelligence",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(
            name: "ArtificialIntelligence",
            targets: ["ArtificialIntelligence"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ml-explore/mlx-swift", exact: "0.31.3"),
        .package(url: "https://github.com/ml-explore/mlx-swift-lm", exact: "2.31.3")
    ],
    targets: [
        .target(
            name: "ArtificialIntelligence",
            dependencies: [
                .product(name: "MLX", package: "mlx-swift"),
                .product(name: "MLXLLM", package: "mlx-swift-lm"),
                .product(name: "MLXLMCommon", package: "mlx-swift-lm")
            ]
        )
    ]
)
