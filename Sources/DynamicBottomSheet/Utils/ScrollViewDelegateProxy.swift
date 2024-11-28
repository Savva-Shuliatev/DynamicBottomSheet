//
//  ScrollViewDelegateProxy.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

internal final class ScrollViewDelegateProxy: NSObject, UIScrollViewDelegate {

  nonisolated(unsafe) private weak var originalDelegate: UIScrollViewDelegate?
  private weak var bottomSheet: DynamicBottomSheet?

  init(
    originalDelegate: UIScrollViewDelegate,
    bottomSheet: DynamicBottomSheet
  ) {
    self.originalDelegate = originalDelegate
    self.bottomSheet = bottomSheet
  }

  // MARK: - Forwarding Unhandled Messages

  override func responds(to aSelector: Selector!) -> Bool {
    return super.responds(to: aSelector) || (originalDelegate?.responds(to: aSelector) ?? false)
  }

  override func forwardingTarget(for aSelector: Selector!) -> Any? {
    if originalDelegate?.responds(to: aSelector) ?? false {
      return originalDelegate
    }
    return super.forwardingTarget(for: aSelector)
  }
}
