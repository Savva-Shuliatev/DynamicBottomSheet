//
//  DampingTimingParameters.swift
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

/// `amplitude` of the damping system towards zero.
internal protocol DampingTimingParameters {
  var duration: TimeInterval { get }
  func value(at time: TimeInterval) -> CGFloat
  func amplitude(at time: TimeInterval) -> CGFloat
}
