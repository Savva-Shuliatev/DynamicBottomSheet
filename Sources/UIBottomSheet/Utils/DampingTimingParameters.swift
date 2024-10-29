//
//  DampingTimingParameters.swift
//  DynamicBottomSheetApp
//
//  Created by Savva Shuliatev.
//

import Foundation
import CoreGraphics

/// `amplitude` of the damping system towards zero.
internal protocol DampingTimingParameters {
  var duration: TimeInterval { get }
  func value(at time: TimeInterval) -> CGFloat
  func amplitude(at time: TimeInterval) -> CGFloat
}
