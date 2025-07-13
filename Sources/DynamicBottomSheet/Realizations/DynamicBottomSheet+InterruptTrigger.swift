//
//  DynamicBottomSheet+InterruptTrigger.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

extension DynamicBottomSheet {

  /// Defines the triggers that can interrupt the bottom sheet's current animation.
  ///
  /// `InterruptTrigger` is an option set that allows you to specify which programmatic actions
  ///  should be able to interrupt the bottom sheet's ongoing animations.
  ///  This provides fine-grained control over the sheet's responsiveness.
  ///
  /// You can combine multiple triggers using set operations to create custom interrupt behaviors.
  ///
  /// Example usage:
  /// ```swift
  /// // Allow only pan gestures to interrupt
  /// let trigger: InterruptTrigger = .panGesture
  ///
  /// // Allow pan gestures and programmatic changes
  /// let trigger: InterruptTrigger = [.panGesture, .program]
  ///
  /// // Allow all interruptions
  /// let trigger: InterruptTrigger = .all
  /// ```
  public struct InterruptTrigger: OptionSet, Sendable {

    public let rawValue: Int

    public static let panGesture = InterruptTrigger(rawValue: 1 << 0)
    public static let scrollDragging = InterruptTrigger(rawValue: 1 << 1)
    public static let program = InterruptTrigger(rawValue: 1 << 2)

    public static let all: InterruptTrigger = [.panGesture, .scrollDragging, .program,]
    public static let empty: InterruptTrigger = []

    public init(rawValue: Int) {
      self.rawValue = rawValue
    }

  }

}
