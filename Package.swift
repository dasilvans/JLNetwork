// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "JLNetwork",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "JLNetwork",
            targets: ["JLNetwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.2.0")),
        .package(url: "https://github.com/datatheorem/TrustKit.git", .upToNextMajor(from: "1.7.0"))
    ],
    targets: [
        .target(
            name: "JLNetwork",
            dependencies: ["Alamofire", "TrustKit"]),
        .testTarget(
            name: "JLNetworkTests",
            dependencies: ["JLNetwork"]),
    ]
)
