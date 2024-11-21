// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "DynamicBottomSheet",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "DynamicBottomSheet",
      targets: ["DynamicBottomSheet"]
    ),
  ],
  targets: [
    .target(
      name: "DynamicBottomSheet"),
    .testTarget(
      name: "DynamicBottomSheetTests",
      dependencies: ["DynamicBottomSheet"]
    ),
  ]
)
