//
//  DynamicBottomSheet+InterruptTrigger.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

extension DynamicBottomSheet {

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
