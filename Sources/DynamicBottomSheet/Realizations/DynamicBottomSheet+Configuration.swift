//
//  DynamicBottomSheet+Configuration.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

extension DynamicBottomSheet {
  @MainActor
  public static var globalConfiguration: Configuration = .default
}

extension DynamicBottomSheet {
  public struct Configuration {
    public var bounces: Bool
    public var bouncesFactor: CGFloat
    public var viewIgnoresTopSafeArea: Bool
    public var viewIgnoresBottomBarHeight: Bool
    public var viewIgnoresBottomSafeArea: Bool
    public var prefersGrabberVisible: Bool
    public var cornerRadius: CGFloat
    public var shadowColor: CGColor?
    public var shadowOpacity: Float
    public var shadowOffset: CGSize
    public var shadowRadius: CGFloat
    public var shadowPath: CGPath?
    public var bottomBarIsHidden: Bool
    public var bottomBarHeight: CGFloat
    public var animationParameters: DynamicBottomSheet.AnimationParameters
    public var detentsConfiguration: Detents.Configuration

    public init(
      bounces: Bool = Configuration.default.bounces,
      bouncesFactor: CGFloat = Configuration.default.bouncesFactor,
      viewIgnoresTopSafeArea: Bool = Configuration.default.viewIgnoresTopSafeArea,
      viewIgnoresBottomBarHeight: Bool = Configuration.default.viewIgnoresBottomBarHeight,
      viewIgnoresBottomSafeArea: Bool = Configuration.default.viewIgnoresBottomSafeArea,
      prefersGrabberVisible: Bool = Configuration.default.prefersGrabberVisible,
      cornerRadius: CGFloat = Configuration.default.cornerRadius,
      shadowColor: CGColor? = Configuration.default.shadowColor,
      shadowOpacity: Float = Configuration.default.shadowOpacity,
      shadowOffset: CGSize = Configuration.default.shadowOffset,
      shadowRadius: CGFloat = Configuration.default.shadowRadius,
      shadowPath: CGPath? = Configuration.default.shadowPath,
      bottomBarIsHidden: Bool = Configuration.default.bottomBarIsHidden,
      bottomBarHeight: CGFloat = Configuration.default.bottomBarHeight,
      animationParameters: DynamicBottomSheet.AnimationParameters = Configuration.default.animationParameters,
      detentsConfiguration: Detents.Configuration = Detents.Configuration.default
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
      self.detentsConfiguration = detentsConfiguration
    }

    public static let `default` = Configuration(
      bounces: true,
      bouncesFactor: 0.1,
      viewIgnoresTopSafeArea: true,
      viewIgnoresBottomBarHeight: false,
      viewIgnoresBottomSafeArea: false,
      prefersGrabberVisible: true,
      cornerRadius: 10.0,
      shadowColor: UIColor.black.withAlphaComponent(0.5).cgColor,
      shadowOpacity: 0.5,
      shadowOffset: CGSize(width: 1.5, height: 1.5),
      shadowRadius: 3.0,
      shadowPath: nil,
      bottomBarIsHidden: true,
      bottomBarHeight: 64.0,
      animationParameters: .spring(.default),
      detentsConfiguration: .default
    )
  }
}

extension DynamicBottomSheet.Detents {
  public struct Configuration {
    public var positions: [RelativePosition]
    public var availablePositions: [RelativePosition]?
    public var bottomBarConnectedPosition: RelativePosition?

    public init(
      positions: [RelativePosition] = Configuration.default.positions,
      availablePositions: [RelativePosition]? = Configuration.default.availablePositions,
      bottomBarConnectedPosition: RelativePosition? = Configuration.default.bottomBarConnectedPosition
    ) {
      self.positions = positions
      self.availablePositions = availablePositions
      self.bottomBarConnectedPosition = bottomBarConnectedPosition
    }

    public static let `default` = Configuration(
      positions: [],
      availablePositions: nil,
      bottomBarConnectedPosition: nil
    )
  }
}
