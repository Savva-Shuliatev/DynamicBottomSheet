//
//  Collection+nearestElement.swift
//  DynamicBottomSheetApp
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
  
  func nearestElement(to value: Element) -> Element? {
    return self.min(by: { abs($0 - value) < abs($1 - value) })
  }
}
