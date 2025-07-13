//
//  FloatingPoint+Projection.swift
//  DynamicBottomSheet
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import Foundation

internal extension FloatingPoint {
  /// Projects a deceleration to its final position.
  /// - Parameters:
  ///   - initialVelocity: The initial velocity value (points per second).
  ///   - decelerationRate: The deceleration rate (must be in range 0..<1).
  /// - Returns: The final projected position. In Release, returns `0` if decelerationRate is invalid.
  @inlinable
  static func project(initialVelocity: Self, decelerationRate: Self) -> Self {
    guard decelerationRate >= 0 && decelerationRate < 1 else {
      assert(decelerationRate >= 0 && decelerationRate < 1, "Deceleration rate must be in range 0..<1")
        return 0
    }

    return initialVelocity * decelerationRate / (1 - decelerationRate)
  }

  func project(initialVelocity: Self, decelerationRate: Self) -> Self {
    return self + Self.project(
      initialVelocity: initialVelocity,
      decelerationRate: decelerationRate
    )
  }
}
