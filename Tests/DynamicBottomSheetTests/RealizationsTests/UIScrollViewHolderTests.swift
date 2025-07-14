//
//  UIScrollViewHolderTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import Testing
@testable import DynamicBottomSheet

@MainActor
final class UIScrollViewHolderTests {

  @Test("Initialization sets up delegate correctly")
  func testInitialization() {
    let scrollView = UIScrollView()
    let bottomSheet = MockBottomSheet()
    let holder = UIScrollViewHolder(scrollView: scrollView, bottomSheet: bottomSheet)
    #expect(scrollView.delegate === holder)
  }

  @Test("Initialization preserves original delegate")
  func testInitializationWithExistingDelegate() {
    let originalDelegate = MockScrollViewDelegate()
    let scrollView = UIScrollView()
    let bottomSheet = MockBottomSheet()

    scrollView.delegate = originalDelegate
    let holder = UIScrollViewHolder(scrollView: scrollView, bottomSheet: bottomSheet)

    #expect(scrollView.delegate === holder)
  }

  @Test("Changing delegate")
  func testChangingDelegate() async {
    let originalDelegate = MockScrollViewDelegate()
    let scrollView = UIScrollView()
    let bottomSheet = MockBottomSheet()

    scrollView.delegate = originalDelegate
    let holder = UIScrollViewHolder(scrollView: scrollView, bottomSheet: bottomSheet)

    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

    scrollView.delegate = originalDelegate
    #expect(scrollView.delegate === holder)
  }

  @Test("Changing delegate")
  func testLeakWhenChangingDelegate() async {
    let originalDelegate = MockScrollViewDelegate()
    let scrollView = UIScrollView()
    let bottomSheet = MockBottomSheet()

    scrollView.delegate = originalDelegate
    var holder: UIScrollViewHolder? = UIScrollViewHolder(scrollView: scrollView, bottomSheet: bottomSheet)
    weak var weakHolder = holder

    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

    scrollView.delegate = originalDelegate
    holder = nil
    ///
    try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds

    #expect(weakHolder == nil)
  }

  @Test("Test all proxy methods")
  func testScrollViewProxy() async {
    let originalDelegate = MockScrollViewDelegate()
    let scrollView = UIScrollView()
    let bottomSheet = MockBottomSheet()

    scrollView.delegate = originalDelegate
    let holder = UIScrollViewHolder(scrollView: scrollView, bottomSheet: bottomSheet)

    scrollView.delegate?.scrollViewDidScroll?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidScroll)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidZoom?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidZoom)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewWillBeginDragging?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewWillBeginDragging)
    originalDelegate.clearReceivedMessages()

    let velocity = CGPoint(x: 1.0, y: 2.0)
    var targetOffset = CGPoint(x: 100, y: 200)
    scrollView.delegate?.scrollViewWillEndDragging?(scrollView, withVelocity: velocity, targetContentOffset: &targetOffset)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewWillEndDragging)
    #expect(originalDelegate.velocity == velocity)
    #expect(originalDelegate.targetContentOffset?.pointee == targetOffset)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: true)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidEndDragging)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewWillBeginDecelerating?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewWillBeginDecelerating)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidEndDecelerating?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidEndDecelerating)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidEndScrollingAnimation)
    originalDelegate.clearReceivedMessages()

    let _ = scrollView.delegate?.viewForZooming?(in: scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedViewForZooming)
    originalDelegate.clearReceivedMessages()

    let testView = UIView()
    scrollView.delegate?.scrollViewWillBeginZooming?(scrollView, with: testView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewWillBeginZooming)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidEndZooming?(scrollView, with: testView, atScale: 2.0)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidEndZooming)
    #expect(originalDelegate.scale == 2.0)
    originalDelegate.clearReceivedMessages()

    let _ = scrollView.delegate?.scrollViewShouldScrollToTop?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewShouldScrollToTop)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidScrollToTop?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidScrollToTop)
    originalDelegate.clearReceivedMessages()

    scrollView.delegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    #expect(originalDelegate.scrollView == scrollView)
    #expect(originalDelegate.receivedScrollViewDidChangeAdjustedContentInset)
    originalDelegate.clearReceivedMessages()

    scrollView.contentOffset = .init(x: .random(in: 0...100), y: .random(in: 0...100))
    holder.contentOffset = scrollView.contentOffset
    }

  }

// MARK: Helpers

private final class MockScrollViewDelegate: NSObject, UIScrollViewDelegate {

  var scrollView: UIScrollView?
  var velocity: CGPoint?
  var targetContentOffset: UnsafeMutablePointer<CGPoint>?
  var decelerate: Bool?
  var scale: CGFloat?

  var receivedScrollViewDidScroll = false
  var receivedScrollViewDidZoom = false
  var receivedScrollViewWillBeginDragging = false
  var receivedScrollViewWillEndDragging = false
  var receivedScrollViewDidEndDragging = false
  var receivedScrollViewWillBeginDecelerating = false
  var receivedScrollViewDidEndDecelerating = false
  var receivedScrollViewDidEndScrollingAnimation = false
  var receivedViewForZooming = false
  var receivedScrollViewWillBeginZooming = false
  var receivedScrollViewDidEndZooming = false
  var receivedScrollViewShouldScrollToTop = false
  var receivedScrollViewDidScrollToTop = false
  var receivedScrollViewDidChangeAdjustedContentInset = false

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewDidScroll = true
  }

  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewDidZoom = true
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewWillBeginDragging = true
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    self.scrollView = scrollView
    self.velocity = velocity
    self.targetContentOffset = targetContentOffset
    receivedScrollViewWillEndDragging = true
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    self.scrollView = scrollView
    self.decelerate = decelerate
    receivedScrollViewDidEndDragging = true
  }

  func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewWillBeginDecelerating = true
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewDidEndDecelerating = true
  }

  func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewDidEndScrollingAnimation = true
  }

  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    self.scrollView = scrollView
    receivedViewForZooming = true
    return nil
  }

  func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
    self.scrollView = scrollView
    receivedScrollViewWillBeginZooming = true
  }

  func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
    self.scrollView = scrollView
    self.scale = scale
    receivedScrollViewDidEndZooming = true
  }

  func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    self.scrollView = scrollView
    receivedScrollViewShouldScrollToTop = true
    return true
  }

  func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewDidScrollToTop = true
  }

  func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
    self.scrollView = scrollView
    receivedScrollViewDidChangeAdjustedContentInset = true
  }

  func clearReceivedMessages() {
    scrollView = nil
    velocity = nil
    targetContentOffset = nil
    decelerate = nil
    scale = nil
    receivedScrollViewDidScroll = false
    receivedScrollViewDidZoom = false
    receivedScrollViewWillBeginDragging = false
    receivedScrollViewWillEndDragging = false
    receivedScrollViewDidEndDragging = false
    receivedScrollViewWillBeginDecelerating = false
    receivedScrollViewDidEndDecelerating = false
    receivedScrollViewDidEndScrollingAnimation = false
    receivedViewForZooming = false
    receivedScrollViewWillBeginZooming = false
    receivedScrollViewDidEndZooming = false
    receivedScrollViewShouldScrollToTop = false
    receivedScrollViewDidScrollToTop = false
    receivedScrollViewDidChangeAdjustedContentInset = false
  }
}

private final class EmptyMockScrollViewDelegate: NSObject, UIScrollViewDelegate {}

private final class MockBottomSheet: DynamicBottomSheet {}
