//
//  ClosedRange+contains.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation

internal extension ClosedRange where Bound: FloatingPoint {

  /// Returns a Boolean value indicating whether the given element is contained within the epsilon-adjusted range.
  ///
  /// Adjusts the range by `eps` in both directions: `[lowerBound - eps, upperBound + eps]`.
  ///
  /// - Parameters:
  ///   - element: The element to check for containment
  ///   - eps: The tolerance value
  /// - Returns: `true` if element is within the adjusted range
  ///
  /// - Note: Positive `eps` expands the range, negative `eps` contracts it
  /// - Note: This method does not handle overflow conditions when `eps` values are extremely large
  ///
  /// - Example:
  ///   ```swift
  ///   let range: ClosedRange = 1.0...3.0
  ///   range.contains(0.95, eps: 0.1) // true
  ///   range.contains(3.1, eps: 0.1)  // true
  ///   range.contains(3.2, eps: 0.1)  // false
  ///   range.contains(3, eps: -0.1)   // false
  ///   ```
  func contains(_ element: Bound, eps: Bound) -> Bool {
    return (element >= lowerBound - eps) && (element <= upperBound + eps)
  }
}
