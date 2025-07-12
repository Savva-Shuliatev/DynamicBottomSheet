//
//  Comparable+clamped.swift
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

internal extension Comparable {

  /// Clamps the value to the specified range.
  /// - Parameter limits: The range to clamp the value to.
  /// - Returns: The value clamped to the given range.
  ///
  /// # Example
  /// ```swift
  /// let value = 15
  /// let clamped = value.clamped(to: 1...10) // Returns 10
  ///
  /// let progress = 1.2
  /// let validProgress = progress.clamped(to: 0.0...1.0) // Returns 1.0
  /// ```
  func clamped(to limits: ClosedRange<Self>) -> Self {
    return min(max(self, limits.lowerBound), limits.upperBound)
  }
}
