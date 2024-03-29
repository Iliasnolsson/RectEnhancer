// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RectEnhancer",
    platforms: [
        .iOS(.v13),
        .macCatalyst(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "RectEnhancer",
            targets: ["RectEnhancer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Iliasnolsson/MathEnhancer", Version(1,0,0)..<Version(2,0,0)),
        .package(url: "https://github.com/Iliasnolsson/CoordinateEnums", Version(1,0,0)..<Version(2,0,0))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "RectEnhancer",
            dependencies: [
                "MathEnhancer",
                "CoordinateEnums"
            ]),
        .testTarget(
            name: "RectEnhancerTests",
            dependencies: ["RectEnhancer"]),
    ]
)
