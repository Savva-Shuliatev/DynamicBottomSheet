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
  
  static func project(initialVelocity: Self, decelerationRate: Self) -> Self {
    if decelerationRate >= 1 {
      assertionFailure()
      return initialVelocity
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
