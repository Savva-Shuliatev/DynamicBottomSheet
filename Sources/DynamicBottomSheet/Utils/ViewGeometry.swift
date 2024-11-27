//
//  ViewGeometry.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

internal struct ViewGeometry: Equatable, Sendable {
  let frame: CGRect
  let bounds: CGRect
  let safeAreaInsets: UIEdgeInsets

  static let zero = ViewGeometry(
    frame: .zero,
    bounds: .zero,
    safeAreaInsets: .zero
  )

  init(
    frame: CGRect,
    bounds: CGRect,
    safeAreaInsets: UIEdgeInsets
  ) {
    self.frame = frame
    self.bounds = bounds
    self.safeAreaInsets = safeAreaInsets
  }

  @MainActor
  init(of view: UIView) {
    self.frame = view.frame
    self.bounds = view.bounds
    self.safeAreaInsets = view.safeAreaInsets
  }

}
