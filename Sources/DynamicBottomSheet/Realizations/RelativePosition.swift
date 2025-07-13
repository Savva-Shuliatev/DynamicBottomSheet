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

/// Structure for defining relative positions of BottomSheet within a container.
/// Allows positioning the sheet relative to screen edges or proportionally to height.
/// Final heights are calculated after layoutSubviews update.
public struct RelativePosition: Equatable, Sendable {

  /// Defines the container edge relative to which the BottomSheet is positioned.
  public enum Edge: Equatable, Sendable {
    /// Top edge of the container
    case top
    /// Middle of the container
    case middle
    /// Bottom edge of the container
    case bottom
    /// Proportional position from 0.0 (top) to 1.0 (bottom)
    case proportion(Double)
  }

  /// Offset in pixels from the base position
  public private(set) var offset: CGFloat

  /// Container edge relative to which positioning occurs
  public private(set) var edge: Edge

  /// Flag to ignore safe areas when calculating position
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

  /// Creates a position with offset from the top edge
  /// - Parameters:
  ///   - offset: Offset downward from the top edge
  ///   - ignoresSafeArea: Whether to ignore safe areas
  /// - Returns: Position relative to the top edge
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

  /// Creates a position exactly at the top edge
  /// - Parameter ignoresSafeArea: Whether to ignore safe areas
  /// - Returns: Position at the top edge with no offset
  public static func top(ignoresSafeArea: Bool = false) -> RelativePosition {
    return RelativePosition(
      offset: 0,
      edge: .top,
      ignoresSafeArea: ignoresSafeArea
    )
  }

  /// Creates a position in the middle of the container
  /// - Parameters:
  ///   - offset: Offset from center (positive - down, negative - up)
  ///   - withSafeArea: Whether to consider safe areas in calculation
  /// - Returns: Position in the middle of the container
  public static func middle(offset: CGFloat = 0, withSafeArea: Bool = true) -> RelativePosition {
    return RelativePosition(
      offset: offset,
      edge: .middle,
      ignoresSafeArea: !withSafeArea
    )
  }

  /// Creates a position with offset from the bottom edge
  /// - Parameters:
  ///   - offset: Offset upward from the bottom edge
  ///   - ignoresSafeArea: Whether to ignore safe areas
  /// - Returns: Position relative to the bottom edge
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

  /// Creates a position exactly at the bottom edge
  /// - Parameter ignoresSafeArea: Whether to ignore safe areas
  /// - Returns: Position at the bottom edge with no offset
  public static func bottom(ignoresSafeArea: Bool = false) -> RelativePosition {
    return RelativePosition(
      offset: 0,
      edge: .bottom,
      ignoresSafeArea: ignoresSafeArea
    )
  }

  /// Predefined position for hidden state of BottomSheet.
  /// Places the sheet below the bottom edge of the screen, ignoring safe areas.
  public static let hidden: RelativePosition = .bottom(ignoresSafeArea: true)

  /// Creates a position proportionally to the container height
  /// - Parameters:
  ///   - proportion: Proportion from 0.0 (top) to 1.0 (bottom)
  ///   - offset: Additional offset in pixels
  ///   - withSafeArea: Whether to consider safe areas in calculation
  /// - Returns: Position at the specified height proportion
  public static func proportion(_ proportion: Double, offset: CGFloat = 0, withSafeArea: Bool = true) -> RelativePosition {
    return RelativePosition(
      offset: offset,
      edge: .proportion(proportion),
      ignoresSafeArea: !withSafeArea
    )
  }

}
