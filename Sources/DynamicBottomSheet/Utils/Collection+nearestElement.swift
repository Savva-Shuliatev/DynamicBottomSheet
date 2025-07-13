//
//  Collection+nearestElement.swift
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

internal extension Collection where Element: Comparable & SignedNumeric {

  /// Finds the element in the collection that is closest to the given value.
  ///
  /// This method compares all elements in the collection and returns the one with the smallest
  /// absolute difference from the target value. If multiple elements have the same distance,
  /// the first one encountered is returned.
  ///
  /// - Parameter value: The target value to find the nearest element to.
  /// - Returns: The element closest to the given value, or `nil` if the collection is empty.
  ///
  /// - Complexity: O(n), where n is the number of elements in the collection.
  ///
  /// - Note: This method requires elements to conform to both `Comparable` and `SignedNumeric`
  ///   to enable distance calculations and comparisons.
  ///
  /// - Warning: Using extreme values (close to type bounds like `Int.min` or `Int.max`) may
  ///   cause integer overflow during distance calculations. Avoid using this method with
  ///   collections containing boundary values or target values that could result in overflow
  ///   when performing subtraction operations.
  ///
  /// Example:
  /// ```swift
  /// let numbers = [1, 5, 3, 9, 7]
  /// let nearest = numbers.nearestElement(to: 6) // Returns 5
  ///
  /// let doubles = [1.2, 3.8, 2.1, 5.5]
  /// let nearestDouble = doubles.nearestElement(to: 2.0) // Returns 2.1
  ///
  /// let emptyArray: [Int] = []
  /// let result = emptyArray.nearestElement(to: 5) // Returns nil
  /// ```
  func nearestElement(to value: Element) -> Element? {
    return self.min(by: { abs($0 - value) < abs($1 - value) })
  }
}
