//
//  FloatingPoint+compare.swift
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

  /// - Returns: `true` if `self < other - eps`, `false` otherwise
  func isLess(than other: Self, eps: Self) -> Bool {
    return self < other - eps
  }

  /// - Returns: `true` if `self > other + eps`, `false` otherwise
  func isGreater(than other: Self, eps: Self) -> Bool {
    return self > other + eps
  }

  /// - Returns: `true` if the absolute difference between values is less than epsilon
  func isEqual(to other: Self, eps: Self) -> Bool {
    return abs(self - other) <= eps
  }
}
