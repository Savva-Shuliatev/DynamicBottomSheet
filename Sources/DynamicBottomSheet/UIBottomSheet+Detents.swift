//
//  DynamicBottomSheet+Detents.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//


import Foundation
import Combine

@MainActor
public protocol DynamicBottomSheetDetentsSubscriber: DynamicBottomSheetSubscriber {
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didChangePosition position: RelativePosition,
    source: DynamicBottomSheet.YChangeSource
  )

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  )

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willMoveTo position: RelativePosition,
    source: DynamicBottomSheet.YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    velocity: CGFloat?
  )
}

extension DynamicBottomSheet {

  @MainActor
  open class Detents {

    internal private(set) weak var bottomSheet: DynamicBottomSheet?

    open var positions: [RelativePosition] = DynamicBottomSheet.Values.default.detentsValues.positions {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        updateAnchors()
      }
    }

    /// Restricts the `move` method and filters `positions: [RelativePosition]`.
    /// By default, it is nil, indicating that all positions are available.
    open var availablePositions: [RelativePosition]? = DynamicBottomSheet.Values.default.detentsValues.availablePositions {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        updateAnchors()
      }
    }

    open var initialPosition: RelativePosition = .fromBottom(0, ignoresSafeArea: true)

    public let onChangePosition = PassthroughSubject<DidChangePositionContext, Never>()
    public let onChangeHeight = PassthroughSubject<DidChangeHeightContext, Never>()
    public let onWillMoveToPosition = PassthroughSubject<WillMoveToContext, Never>()

    private var subscribers = Subscribers<DynamicBottomSheetDetentsSubscriber>()

    public init(bottomSheet: DynamicBottomSheet) {
      self.bottomSheet = bottomSheet
      bottomSheet.subscribe(self)
    }

    // MARK: - Public methods

    open func subscribe(_ subscriber: DynamicBottomSheetDetentsSubscriber) {
      subscribers.subscribe(subscriber)
    }

    open func unsubscribe(_ subscriber: DynamicBottomSheetDetentsSubscriber) {
      subscribers.unsubscribe(subscriber)
    }

    open func move(
      to position: RelativePosition,
      animated: Bool = true,
      interruptTriggers: DynamicBottomSheet.InterruptTrigger = .all,
      completion: ((Bool) -> Void)? = nil
    ) {
      guard let bottomSheet, bottomSheet.didLayoutSubviews else {
        initialPosition = position
        completion?(true)
        return
      }

      bottomSheet.scroll(
        to: y(for: position),
        animated: animated,
        interruptTriggers: interruptTriggers,
        completion: completion
      )
    }

    open func y(for position: RelativePosition) -> CGFloat {
      guard let bottomSheet, bottomSheet.didLayoutSubviews else { return 0 }

      switch position.edge {
      case .top:
        var y: CGFloat = position.offset

        if !position.ignoresSafeArea {
          y += bottomSheet.safeAreaInsets.top
        }

        return y

      case .middle:
        var y: CGFloat = 0

        if position.ignoresSafeArea {
          y = bottomSheet.bounds.height / 2
        } else {
          y = (bottomSheet.bounds.height - bottomSheet.safeAreaInsets.top - bottomSheet.safeAreaInsets.bottom) / 2
        }

        y += position.offset

        return y

      case .bottom:
        var y: CGFloat = bottomSheet.bounds.height - position.offset

        if !position.ignoresSafeArea {
          y -= bottomSheet.safeAreaInsets.bottom
        }

        return y

      case .proportion(let proportion):
        guard proportion >= 0, proportion <= 1 else { return 0 }

        var y: CGFloat = 0

        if position.ignoresSafeArea {
          y = bottomSheet.bounds.height * proportion
        } else {
          y = (bottomSheet.bounds.height - bottomSheet.safeAreaInsets.top - bottomSheet.safeAreaInsets.bottom) * proportion
        }

        y += position.offset

        return y
      }
    }

    open func value(
      from position1: RelativePosition,
      to position2: RelativePosition
    ) -> Double {
      guard let bottomSheet,bottomSheet.didLayoutSubviews else { return 0 }

      let y1 = y(for: position1)
      let y2 = y(for: position2)
      let y = bottomSheet.y

      if y1 == y2 {
        return 1

      } else if y1 > y2 {
        return 1.0 - min(max(y - y2, 0) / (y1 - y2), 1)

      } else {
        return min(max(y - y1, 0) / (y2 - y1), 1)
      }
    }

    // MARK: - Private methods

    internal func updateAnchors() {
      guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }

      if let availablePositions {
        bottomSheet.anchors = positions
          .filter { availablePositions.contains($0) }
          .map { y(for: $0) }

      } else {
        bottomSheet.anchors = positions
          .map { y(for: $0) }
      }
    }
  }

}

// MARK: DynamicBottomSheetSubscriber

extension DynamicBottomSheet.Detents: DynamicBottomSheetSubscriber {
  public func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        willBeginUpdatingY: y,
        source: source
      )
    }
  }

  public func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didUpdateY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        didUpdateY: y,
        source: source
      )
    }

    let height = bottomSheet.bounds.height - y
    let bottomSafeAreaInset = bottomSheet.safeAreaInsets.bottom

    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        height: height,
        bottomSafeAreaInset: bottomSafeAreaInset,
        source: source
      )
    }

    onChangeHeight.send(DidChangeHeightContext(height: height, bottomSafeAreaInset: bottomSafeAreaInset, source: source))
  }

  public func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        didEndUpdatingY: y,
        source: source
      )
    }

    let availablePositions = availablePositions ?? positions
    availablePositions.forEach { position in
      if self.y(for: position).isEqual(to: y, eps: 1) {
        subscribers.forEach {
          $0.bottomSheet(
            bottomSheet,
            didChangePosition: position,
            source: source
          )
        }

        onChangePosition.send(DidChangePositionContext(position: position, source: source))
        return
      }
    }
  }

  public func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginAnimation animation: DynamicBottomSheetAnimation,
    source: DynamicBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        willBeginAnimation: animation,
        source: source
      )
    }
  }

  public func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willMoveTo newY: CGFloat,
    source: DynamicBottomSheet.YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    velocity: CGFloat?
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        willMoveTo: newY,
        source: source,
        animated: animated,
        interruptTriggers: interruptTriggers,
        velocity: velocity
      )
    }

    let availablePositions = availablePositions ?? positions
    availablePositions.forEach { position in
      if self.y(for: position).isEqual(to: newY, eps: 1) {
        subscribers.forEach {
          $0.bottomSheet(
            bottomSheet,
            willMoveTo: position,
            source: source,
            animated: animated,
            interruptTriggers: interruptTriggers,
            velocity: velocity
          )
        }

        onWillMoveToPosition.send(
          WillMoveToContext(
            position: position,
            source: source,
            animated: animated,
            interruptTriggers: interruptTriggers,
            velocity: velocity
          )
        )

        return
      }
    }

  }

}

// MARK: Default DynamicBottomSheetDetentsSubscriber

public extension DynamicBottomSheetDetentsSubscriber {
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didChangePosition position: RelativePosition,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willMoveTo position: RelativePosition,
    source: DynamicBottomSheet.YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    velocity: CGFloat?
  ) {}

}

// MARK: Contexts for publishers

extension DynamicBottomSheet.Detents {

  public struct DidChangePositionContext: Sendable, Equatable {
    public let position: RelativePosition
    public let source: DynamicBottomSheet.YChangeSource

    public init(position: RelativePosition, source: DynamicBottomSheet.YChangeSource) {
      self.position = position
      self.source = source
    }
  }

  public struct DidChangeHeightContext: Sendable, Equatable {
    public let height: CGFloat
    public let bottomSafeAreaInset: CGFloat
    public let source: DynamicBottomSheet.YChangeSource

    public init(
      height: CGFloat,
      bottomSafeAreaInset: CGFloat,
      source: DynamicBottomSheet.YChangeSource
    ) {
      self.height = height
      self.bottomSafeAreaInset = bottomSafeAreaInset
      self.source = source
    }
  }

  public struct WillMoveToContext: Sendable, Equatable {
    public let position: RelativePosition
    public let source: DynamicBottomSheet.YChangeSource
    public let animated: Bool
    public let interruptTriggers: DynamicBottomSheet.InterruptTrigger
    public let velocity: CGFloat?

    public init(
      position: RelativePosition,
      source: DynamicBottomSheet.YChangeSource,
      animated: Bool,
      interruptTriggers: DynamicBottomSheet.InterruptTrigger,
      velocity: CGFloat?
    ) {
      self.position = position
      self.source = source
      self.animated = animated
      self.interruptTriggers = interruptTriggers
      self.velocity = velocity
    }
  }

}
