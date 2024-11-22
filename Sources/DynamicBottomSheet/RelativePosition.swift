//
//  RelativePosition.swift
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

public struct RelativePosition: Equatable {
  public enum Edge: Equatable {
    case top
    case middle
    case bottom
    case proportion(Double)
  }

  public private(set) var offset: CGFloat
  public private(set) var edge: Edge
  public private(set) var ignoresSafeArea: Bool

  internal init(
    offset: CGFloat,
    edge: Edge,
    ignoresSafeArea: Bool = false
  ) {
    self.offset = offset
    self.edge = edge
    self.ignoresSafeArea = ignoresSafeArea
  }

  public static func fromTop(
    _ offset: CGFloat,
    ignoresSafeArea: Bool = false
  ) -> RelativePosition {
    return RelativePosition(
      offset: offset,
      edge: .top,
      ignoresSafeArea: ignoresSafeArea
    )
  }

  public static func top(ignoresSafeArea: Bool = false) -> RelativePosition {
    return RelativePosition(
      offset: 0,
      edge: .top,
      ignoresSafeArea: ignoresSafeArea
    )
  }

  public static func middle(offset: CGFloat = 0, withSafeArea: Bool = true) -> RelativePosition {
    return RelativePosition(
      offset: offset,
      edge: .middle,
      ignoresSafeArea: !withSafeArea
    )
  }

  public static func fromBottom(
    _ offset: CGFloat,
    ignoresSafeArea: Bool = false
  ) -> RelativePosition {
    return RelativePosition(
      offset: offset,
      edge: .bottom,
      ignoresSafeArea: ignoresSafeArea
    )
  }

  public static func bottom(ignoresSafeArea: Bool = false) -> RelativePosition {
    return RelativePosition(
      offset: 0,
      edge: .bottom,
      ignoresSafeArea: ignoresSafeArea
    )
  }

  @MainActor
  public static let hidden: RelativePosition = .bottom(ignoresSafeArea: true)

  public func proportion(_ proportion: Double, offset: CGFloat = 0, withSafeArea: Bool = true) -> RelativePosition {
    return RelativePosition(
      offset: offset,
      edge: .proportion(proportion),
      ignoresSafeArea: !withSafeArea
    )
  }

}
