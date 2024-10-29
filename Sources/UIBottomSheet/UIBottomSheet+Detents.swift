//
//  UIBottomSheet+Detents.swift
//  DynamicBottomSheetApp
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import Foundation

extension UIBottomSheet {

  @MainActor
  open class Detents {

    internal private(set) weak var bottomSheet: UIBottomSheet?

    open var positions: [RelativePosition] = [] {
      didSet {
        guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }
        bottomSheet.anchors = positions.map { y(for: $0) }
      }
    }

    open var initialPosition: RelativePosition = .fromBottom(0, ignoresSafeArea: true)

    init(bottomSheet: UIBottomSheet) {
      self.bottomSheet = bottomSheet
    }

    open func move(
      to position: RelativePosition,
      animated: Bool = true,
      completion: ((Bool) -> Void)? = nil
    ) {
      guard let bottomSheet, bottomSheet.didLayoutSubviews else { return }

      bottomSheet.scroll(
        to: y(for: position),
        animated: animated,
        completion: completion
      )
    }

    open func y(for position: RelativePosition) -> CGFloat {
      guard let bottomSheet, bottomSheet.didLayoutSubviews else { return 0 }

      switch position.edge {
      case .top:
        var y: CGFloat = position.offset

        if !position.ignoresSafeArea {
          y += bottomSheet.safeAreaInsets.top
        }

        return y

      case .middle:
        var y: CGFloat = 0

        if position.ignoresSafeArea {
          y = bottomSheet.bounds.height / 2
        } else {
          y = (bottomSheet.bounds.height - bottomSheet.safeAreaInsets.top - bottomSheet.safeAreaInsets.bottom) / 2
        }

        y += position.offset

        return y

      case .bottom:
        var y: CGFloat = bottomSheet.bounds.height - position.offset

        if !position.ignoresSafeArea {
          y -= bottomSheet.safeAreaInsets.bottom
        }

        return y

      case .proportion(let proportion):
        guard proportion >= 0, proportion <= 1 else { return 0 }

        var y: CGFloat = 0

        if position.ignoresSafeArea {
          y = bottomSheet.bounds.height * proportion
        } else {
          y = (bottomSheet.bounds.height - bottomSheet.safeAreaInsets.top - bottomSheet.safeAreaInsets.bottom) * proportion
        }

        y += position.offset

        return y
      }
    }

  }
}
