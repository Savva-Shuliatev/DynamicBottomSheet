//
//  ClosedRange+contains.swift
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

internal extension ClosedRange where Bound: FloatingPoint {
  
  func contains(_ element: Bound, eps: Bound) -> Bool {
    return element.isGreater(than: lowerBound, eps: eps) && element.isLess(than: upperBound, eps: eps)
  }
}
