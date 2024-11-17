//
//  LeaksTests.swift
//  UIBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import UIBottomSheet
import UIKit

@Suite("Leaks Tests")
struct LeaksTests {

  @Test @MainActor
  func memoryLeak() async throws {
    var bottomSheet: UIBottomSheet? = UIBottomSheet()
    weak var weakBottomSheet: UIBottomSheet? = bottomSheet

    let view = UIView()
    view.addSubview(bottomSheet!)

    bottomSheet = nil
    weakBottomSheet!.detents.initialPosition = .bottom()

    weakBottomSheet!.removeFromSuperview()

    try await Task.sleep(nanoseconds: 100_000_000)

    #expect(weakBottomSheet == nil)
  }

  @Test @MainActor
  func detentsLeak() {
    let bottomSheet = UIBottomSheet()
    #expect(bottomSheet.detents.bottomSheet === bottomSheet)
  }

}

