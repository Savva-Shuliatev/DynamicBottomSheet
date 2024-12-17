//
//  LeaksTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet
import UIKit

@Suite("Leaks Tests")
@MainActor
struct LeaksTests {

  @Test
  func memoryLeak() async throws {
    var bottomSheet: DynamicBottomSheet? = DynamicBottomSheet()
    weak var weakBottomSheet: DynamicBottomSheet? = bottomSheet

    let view = UIView()
    view.addSubview(bottomSheet!)

    bottomSheet = nil
    weakBottomSheet!.detents.initialPosition = .bottom()

    weakBottomSheet!.removeFromSuperview()

    try await Task.sleep(nanoseconds: 100_000_000)

    #expect(weakBottomSheet == nil)
  }

  @Test
  func detentsLeak() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.detents.bottomSheet === bottomSheet)
  }

  @Test
  func bottomBarLeak() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.bottomBar.bottomSheet === bottomSheet)
  }

  @Test
  func scrollViewIntegrationLeakTests() {
    let bottomSheet: DynamicBottomSheet? = DynamicBottomSheet()
    var scrollView: UIScrollView? = UIScrollView()

    bottomSheet!.connect(scrollView!)

    scrollView = nil
    #expect(scrollView == nil)
  }

  @Test
  func scrollingContentIntegrationLeakTests() {
    let bottomSheet: DynamicBottomSheet? = DynamicBottomSheet()
    var scrollView: TestScrollContent? = TestScrollContent()

    bottomSheet!.connect(scrollView!)

    scrollView = nil
    #expect(scrollView == nil)
  }

  private final class TestScrollContent: DynamicBottomSheet.ScrollingContent {
    var contentOffset: CGPoint = .zero
    func stopScrolling() {}
  }

}


