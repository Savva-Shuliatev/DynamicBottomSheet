//
//  UIScrollViewHolder.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

@MainActor
internal final class UIScrollViewHolder: NSObject, UIScrollViewDelegate {

  private weak var scrollView: UIScrollView?
  private weak var bottomSheet: DynamicBottomSheet?

  nonisolated(unsafe) private weak var originalDelegate: UIScrollViewDelegate?
  private var observeDelegate: NSKeyValueObservation?

  init(scrollView: UIScrollView, bottomSheet: DynamicBottomSheet) {
    super.init()
    self.scrollView = scrollView
    self.bottomSheet = bottomSheet
    observeDelegate(on: scrollView)
    originalDelegate = scrollView.delegate
    scrollView.delegate = self
  }

  private func observeDelegate(on scrollView: UIScrollView) {
    observeDelegate = scrollView.observe(\.delegate, options: [.new, .old]) { [weak self] _, value in
      guard
        let self,
        let newDelegate = value.newValue,
        newDelegate !== self
      else { return }

      DispatchQueue.main.async {
        self.originalDelegate = scrollView.delegate
        scrollView.delegate = self
      }
    }
  }

  // MARK: - UIScrollViewDelegate

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    bottomSheet?.scrollViewWillBeginDragging(with: scrollView.contentOffset)
    originalDelegate?.scrollViewWillBeginDragging?(scrollView)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    bottomSheet?.scrollViewDidScroll(
      contentOffset: scrollView.contentOffset,
      contentInset: scrollView.contentInset
    )
    originalDelegate?.scrollViewDidScroll?(scrollView)
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    bottomSheet?.scrollViewWillEndDragging(
      withVelocity: velocity,
      targetContentOffset: targetContentOffset
    )

    originalDelegate?.scrollViewWillEndDragging?(
      scrollView,
      withVelocity: velocity,
      targetContentOffset: targetContentOffset
    )
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

extension UIScrollViewHolder: DynamicBottomSheet.ScrollingContent {
  var contentOffset: CGPoint {
    get { scrollView?.contentOffset ?? .zero }
    set { scrollView?.contentOffset = newValue }
  }
  
  func stopScrolling() {
    guard let scrollView else { return }
    scrollView.setContentOffset(CGPoint(x: 0, y: -scrollView.contentInset.top), animated: false)
  }

}

internal enum ScrollingContentHolder {
  case scrollViewHolder(UIScrollViewHolder)
  case scrollingContent(WeakscrollingContentBox)

  var scrollingContent: DynamicBottomSheet.ScrollingContent? {
    switch self {
    case .scrollViewHolder(let scrollViewHolder):
      return scrollViewHolder
    case .scrollingContent(let scrollingContentBox):
      return scrollingContentBox.scrollingContent
    }
  }
}

internal struct WeakscrollingContentBox {

  weak var scrollingContent: DynamicBottomSheet.ScrollingContent?

  static func weak(_ scrollingContent: DynamicBottomSheet.ScrollingContent) -> WeakscrollingContentBox {
    .init(scrollingContent: scrollingContent)
  }
}
