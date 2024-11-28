//
//  DynamicBottomSheet+Values.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

@preconcurrency import UIKit

extension DynamicBottomSheet {

  public struct Values: Sendable {
    public var bounces: Bool
    public var bouncesFactor: CGFloat
    public var viewIgnoresTopSafeArea: Bool
    public var viewIgnoresBottomBarHeight: Bool = false
    public var viewIgnoresBottomSafeArea: Bool = false
    public var prefersGrabberVisible: Bool = true
    public var cornerRadius: CGFloat
    public var shadowColor: CGColor?
    public var shadowOpacity: Float
    public var shadowOffset: CGSize
    public var shadowRadius: CGFloat
    public var shadowPath: CGPath?
    public var bottomBarIsHidden: Bool
    public var bottomBarHeight: CGFloat
    public var animationParameters: DynamicBottomSheet.AnimationParameters
    public var detentsValues: Detents.Values

    public init(
      bounces: Bool,
      bouncesFactor: CGFloat,
      viewIgnoresTopSafeArea: Bool,
      viewIgnoresBottomBarHeight: Bool,
      viewIgnoresBottomSafeArea: Bool,
      prefersGrabberVisible: Bool,
      cornerRadius: CGFloat,
      shadowColor: CGColor?,
      shadowOpacity: Float,
      shadowOffset: CGSize,
      shadowRadius: CGFloat,
      shadowPath: CGPath?,
      bottomBarIsHidden: Bool,
      bottomBarHeight: CGFloat,
      animationParameters: DynamicBottomSheet.AnimationParameters,
      detentsValues: Detents.Values
    ) {
      self.bounces = bounces
      self.bouncesFactor = bouncesFactor
      self.viewIgnoresTopSafeArea = viewIgnoresTopSafeArea
      self.viewIgnoresBottomBarHeight = viewIgnoresBottomBarHeight
      self.viewIgnoresBottomSafeArea = viewIgnoresBottomSafeArea
      self.prefersGrabberVisible = prefersGrabberVisible
      self.cornerRadius = cornerRadius
      self.shadowColor = shadowColor
      self.shadowOpacity = shadowOpacity
      self.shadowOffset = shadowOffset
      self.shadowRadius = shadowRadius
      self.shadowPath = shadowPath
      self.bottomBarIsHidden = bottomBarIsHidden
      self.bottomBarHeight = bottomBarHeight
      self.animationParameters = animationParameters
      self.detentsValues = detentsValues
    }

    @MainActor
    public static var `default`: Values = Values(
      bounces: true,
      bouncesFactor: 0.1,
      viewIgnoresTopSafeArea: true,
      viewIgnoresBottomBarHeight: false,
      viewIgnoresBottomSafeArea: false,
      prefersGrabberVisible: true,
      cornerRadius: 10,
      shadowColor: UIColor.black.withAlphaComponent(0.5).cgColor,
      shadowOpacity: 0.5,
      shadowOffset: CGSize(width: 1.5, height: 1.5),
      shadowRadius: 3.0,
      shadowPath: nil,
      bottomBarIsHidden: true,
      bottomBarHeight: 64,
      animationParameters: .spring(.default),
      detentsValues: .default
    )
  }
}

extension DynamicBottomSheet.Detents {
  public struct Values: Sendable {
    public var positions: [RelativePosition]
    public var availablePositions: [RelativePosition]?
    public var bottomBarConnectedPosition: RelativePosition?

    public init(
      positions: [RelativePosition],
      availablePositions: [RelativePosition]?,
      bottomBarConnectedPosition: RelativePosition?
    ) {
      self.positions = positions
      self.availablePositions = availablePositions
      self.bottomBarConnectedPosition = bottomBarConnectedPosition
    }

    @MainActor
    public static var `default` = Values(
      positions: [],
      availablePositions: nil,
      bottomBarConnectedPosition: nil
    )
  }
}
