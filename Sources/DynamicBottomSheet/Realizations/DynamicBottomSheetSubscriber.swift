//
//  DynamicBottomSheetSubscriber.swift
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

@MainActor
public protocol DynamicBottomSheetSubscriber: AnyObject {
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  )
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didUpdateY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  )
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  )
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginAnimation animation: DynamicBottomSheetAnimation,
    source: DynamicBottomSheet.YChangeSource
  )

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willMoveTo newY: CGFloat,
    source: DynamicBottomSheet.YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    velocity: CGFloat?
  )
}

// MARK: Default

public extension DynamicBottomSheetSubscriber {
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didUpdateY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginAnimation animation: DynamicBottomSheetAnimation,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willMoveTo newY: CGFloat,
    source: DynamicBottomSheet.YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    velocity: CGFloat?
  ) {}
}
