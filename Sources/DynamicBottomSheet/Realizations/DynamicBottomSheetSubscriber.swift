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

// MARK: Contexts for publishers

extension DynamicBottomSheet {

  public struct WillBeginUpdatingYContext: Sendable, Equatable {
    public let y: CGFloat
    public let source: DynamicBottomSheet.YChangeSource

    public init(y: CGFloat, source: DynamicBottomSheet.YChangeSource) {
      self.y = y
      self.source = source
    }
  }

  public struct DidUpdateYContext: Sendable, Equatable {
    public let y: CGFloat
    public let source: DynamicBottomSheet.YChangeSource

    public init(y: CGFloat, source: DynamicBottomSheet.YChangeSource) {
      self.y = y
      self.source = source
    }
  }

  public struct DidEndUpdatingYContext: Sendable, Equatable {
    public let y: CGFloat
    public let source: DynamicBottomSheet.YChangeSource

    public init(y: CGFloat, source: DynamicBottomSheet.YChangeSource) {
      self.y = y
      self.source = source
    }
  }

  public struct WillBeginAnimationContext {
    public let animation: DynamicBottomSheetAnimation
    public let source: DynamicBottomSheet.YChangeSource

    public init(animation: DynamicBottomSheetAnimation, source: DynamicBottomSheet.YChangeSource) {
      self.animation = animation
      self.source = source
    }
  }

  public struct WillMoveToContext: Sendable, Equatable {
    public let newY: CGFloat
    public let source: DynamicBottomSheet.YChangeSource
    public let animated: Bool
    public let interruptTriggers: DynamicBottomSheet.InterruptTrigger
    public let velocity: CGFloat?

    public init(
      newY: CGFloat,
      source: DynamicBottomSheet.YChangeSource,
      animated: Bool,
      interruptTriggers: DynamicBottomSheet.InterruptTrigger,
      velocity: CGFloat?
    ) {
      self.newY = newY
      self.source = source
      self.animated = animated
      self.interruptTriggers = interruptTriggers
      self.velocity = velocity
    }
  }

}
