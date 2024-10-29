// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "UIBottomSheet",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "UIBottomSheet",
      targets: ["UIBottomSheet"]
    ),
  ],
  targets: [
    .target(
      name: "UIBottomSheet"),
    .testTarget(
      name: "UIBottomSheetTests",
      dependencies: ["UIBottomSheet"]
    ),
  ]
)
