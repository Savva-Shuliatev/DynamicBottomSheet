//
//  DynamicBottomSheetAnimation.swift
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

/// DynamicBottomSheetAnimation allows to control y during animation.
@MainActor
public protocol DynamicBottomSheetAnimation: AnyObject {
  var y: CGFloat { get set }
  var isDone: Bool { get }
}
