//
//  ClosedRange+contains.swift
//  DynamicBottomSheetApp
//
//  Created by Savva Shuliatev.
//

import Foundation

internal extension ClosedRange where Bound: FloatingPoint {
  
  func contains(_ element: Bound, eps: Bound) -> Bool {
    return element.isGreater(than: lowerBound, eps: eps) && element.isLess(than: upperBound, eps: eps)
  }
}
