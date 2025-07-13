//
//  DynamicBottomSheet+BottomBar.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

extension DynamicBottomSheet {

  @MainActor
  open class BottomBar {

    internal weak var bottomSheet: DynamicBottomSheet?

    public let area = UIView()
    public let view = UIView()

    open private(set) var height: CGFloat {
      didSet {
        bottomSheet?.bottomBarHeightConstraint?.constant = height
      }
    }

    open var viewIgnoresBottomBarHeight: Bool {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        bottomSheet.updateViewHeight()
      }
    }

    open var isHidden: Bool {
      didSet {
        guard let bottomSheet else { return }
        area.isHidden = isHidden
        view.isHidden = isHidden
        guard bottomSheet.didLayoutSubviews else { return }
        bottomSheet.updateViewHeight()
      }
    }

    /// If value is nil, then substitute the last position from positions or full height of container
    open var connectedPosition: RelativePosition? {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        bottomSheet.updateBottomBarAreaHeight()
      }
    }

    public init(configuration: Configuration) {
      self.connectedPosition = configuration.detentsConfiguration.bottomBarConnectedPosition
      self.height = configuration.bottomBarHeight
      self.viewIgnoresBottomBarHeight = configuration.viewIgnoresBottomBarHeight
      self.isHidden = configuration.bottomBarIsHidden
    }

    open func updateHeight(_ height: CGFloat) {
      self.height = max(height, 0)
      guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
      bottomSheet.updateBottomBarAreaHeight()
      bottomSheet.updateViewHeight()
    }

  }

}
