//
//  DynamicBottomSheet+BottomBar.swift
//  DynamicBottomSheet
//
//  Created by Savva Shuliatev on 27.11.2024.
//

import UIKit

extension DynamicBottomSheet {

  @MainActor
  open class BottomBar {

    internal weak var bottomSheet: DynamicBottomSheet?

    public let area = UIView()
    public let view = UIView()

    open var viewIgnoresBottomBarHeight: Bool = Values.default.viewIgnoresBottomBarHeight {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        bottomSheet.layoutSubviews()
      }
    }

    public init(bottomSheet: DynamicBottomSheet) {
      self.bottomSheet = bottomSheet
    }

  }

}
