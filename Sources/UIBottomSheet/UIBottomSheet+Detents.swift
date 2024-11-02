//
//  UIBottomSheet+Detents.swift
//  DynamicBottomSheetApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//


import Foundation

@MainActor
public protocol UIBottomSheetDetentsSubscriber: UIBottomSheetSubscriber {
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didChangePosition position: RelativePosition,
    source: UIBottomSheet.YChangeSource
  )

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: UIBottomSheet.YChangeSource
  )
}

extension UIBottomSheet {

  @MainActor
  open class Detents {

    internal private(set) weak var bottomSheet: UIBottomSheet?

    open var positions: [RelativePosition] = [] {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        bottomSheet.anchors = positions.map { y(for: $0) }
      }
    }

    open var initialPosition: RelativePosition = .fromBottom(0, ignoresSafeArea: true)

    private var subscribers = Subscribers<UIBottomSheetDetentsSubscriber>()

    public init(bottomSheet: UIBottomSheet) {
      self.bottomSheet = bottomSheet
    }

    // MARK: - Public methods

    open func subscribe(_ subscriber: UIBottomSheetDetentsSubscriber) {
      subscribers.subscribe(subscriber)
    }

    open func unsubscribe(_ subscriber: UIBottomSheetDetentsSubscriber) {
      subscribers.unsubscribe(subscriber)
    }

    open func move(
      to position: RelativePosition,
      animated: Bool = true,
      completion: ((Bool) -> Void)? = nil
    ) {
      guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }

      bottomSheet.scroll(
        to: y(for: position),
        animated: animated,
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

  }
}

// MARK: UIBottomSheetSubscriber

extension UIBottomSheet.Detents: UIBottomSheetSubscriber {
  public func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
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
    _ bottomSheet: UIBottomSheet,
    didUpdateY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        didUpdateY: y,
        source: source
      )
    }

    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        height: bottomSheet.bounds.height - y,
        bottomSafeAreaInset: bottomSheet.safeAreaInsets.bottom,
        source: source
      )
    }
  }

  public func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        didEndUpdatingY: y,
        source: source
      )
    }

    positions.forEach { position in
      if self.y(for: position).isEqual(to: y, eps: 1) {
        subscribers.forEach {
          $0.bottomSheet(
            bottomSheet,
            didChangePosition: position,
            source: source
          )
        }

        return
      }
    }
  }

  public func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginAnimation animation: UIBottomSheetAnimation,
    source: UIBottomSheet.YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        bottomSheet,
        willBeginAnimation: animation,
        source: source
      )
    }
  }
}

// MARK: Default UIBottomSheetDetentsSubscriber

public extension UIBottomSheetDetentsSubscriber {
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didChangePosition position: RelativePosition,
    source: UIBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {}
}
