//
//  Rubber.swift
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
import CoreGraphics

struct Rubber {

  @available(*, unavailable)
  private init() {}

  /// - Returns: The rubber band adjusted value, always less than the input for positive values
  static func bandClamp(_ x: CGFloat, coeff: CGFloat = 0.55, dim: CGFloat) -> CGFloat {
    return (1.0 - (1.0 / ((x * coeff / dim) + 1.0))) * dim
  }

  /// - Returns: A value that stays within reasonable bounds but allows soft overflow with diminishing returns
  static func bandClamp(_ x: CGFloat, coeff: CGFloat = 0.55, limits: ClosedRange<CGFloat>) -> CGFloat {
    let clampedX = x.clamped(to: limits)
    let diff = abs(x - clampedX)
    let sign: CGFloat = clampedX > x ? -1 : 1
    let dim = limits.upperBound - limits.lowerBound
    return clampedX + sign * bandClamp(diff, coeff: coeff, dim: dim)
  }
}
