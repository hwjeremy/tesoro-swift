// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TesoroAPI",
    platforms: [.macOS(.v14), .watchOS(.v10), .iOS(.v17), .visionOS(.v1)],
    products: [
        .library(
            name: "TesoroAPI",
            targets: ["TesoroAPI"]
        ),
    ],
    /*dependencies: [
        .package(
            url: "https://github.com/swift-server/async-http-client.git",
            from: "1.9.0"
        )
    ],*/
    targets: [
        .target(
            name: "TesoroAPI"
            /*dependencies: [
                .product(
                    name: "AsyncHTTPClient",
                    package: "async-http-client",
                    condition: .when(platforms: [.linux])
                )
            ]*/
        ),
        .testTarget(
            name: "TesoroAPITests",
            dependencies: ["TesoroAPI"]
        )
    ]
)
