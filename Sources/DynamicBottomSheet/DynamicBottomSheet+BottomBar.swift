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

    open var isHidden: Bool = Values.default.bottomBarIsHidden {
      didSet {
        guard let bottomSheet else { return }
        area.isHidden = isHidden
        view.isHidden = isHidden
        guard bottomSheet.didLayoutSubviews else { return }
        bottomSheet.layoutSubviews()
      }
    }

    /// If value is nil, then substitute the last position from positions or full height of container
    open var connectedPosition: RelativePosition? = Values.default.detentsValues.bottomBarConnectedPosition {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        bottomSheet.updateBottomBarAreaHeight()
      }
    }

    public init(bottomSheet: DynamicBottomSheet) {
      self.bottomSheet = bottomSheet
    }

  }

}
