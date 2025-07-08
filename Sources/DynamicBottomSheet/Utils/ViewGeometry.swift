//
//  ViewGeometry.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

public struct ViewGeometry: Equatable, Sendable {
  public let frame: CGRect
  public let bounds: CGRect
  public let safeAreaInsets: UIEdgeInsets

  public static let zero = ViewGeometry(
    frame: .zero,
    bounds: .zero,
    safeAreaInsets: .zero
  )

  public init(
    frame: CGRect,
    bounds: CGRect,
    safeAreaInsets: UIEdgeInsets
  ) {
    self.frame = frame
    self.bounds = bounds
    self.safeAreaInsets = safeAreaInsets
  }

  @MainActor
  public init(of view: UIView) {
    self.frame = view.frame
    self.bounds = view.bounds
    self.safeAreaInsets = view.safeAreaInsets
  }

}
