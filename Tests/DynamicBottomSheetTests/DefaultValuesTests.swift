//
//  DefaultValuesTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet
import UIKit

@Suite("Default values Tests")
@MainActor
struct DefaultValuesTests {

  @Test
  func defaultValues() {
    let bottomSheet = DynamicBottomSheet(configuration: .default)

    #expect(bottomSheet.y == 0)
    #expect(bottomSheet.bounces)
    #expect(bottomSheet.bouncesFactor == 0.1)
    #expect(bottomSheet.viewIgnoresTopSafeArea)
    #expect(!bottomSheet.bottomBar.viewIgnoresBottomBarHeight)
    #expect(!bottomSheet.viewIgnoresBottomSafeArea)
    #expect(bottomSheet.animationParameters == .spring(.default))
    #expect(bottomSheet.prefersGrabberVisible)
    #expect(bottomSheet.cornerRadius == 10)
    #expect(bottomSheet.shadowColor == UIColor.black.withAlphaComponent(0.5).cgColor)
    #expect(bottomSheet.shadowOpacity == 0.5)
    #expect(bottomSheet.shadowOffset == CGSize(width: 1.5, height: 1.5))
    #expect(bottomSheet.shadowRadius == 3.0)
    #expect(bottomSheet.shadowPath == nil)
    #expect(bottomSheet.bottomBar.isHidden)
    #expect(bottomSheet.bottomBar.height == 64)
    #expect(bottomSheet.prefersGrabberVisible)
  }

  @Test
  func defaultDetentsValues() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.detents.positions.isEmpty)
    #expect(bottomSheet.bottomBar.connectedPosition == nil)
    #expect(bottomSheet.detents.initialPosition == .fromBottom(0, ignoresSafeArea: true))
    #expect(bottomSheet.detents.availablePositions == nil)
  }

  @Test
  func valuesInSheet() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.bounces == DynamicBottomSheet.Configuration.default.bounces)
  }

  @Test
  func realizationValues() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.anchors.isEmpty)
    #expect(!bottomSheet.didLayoutSubviews)
  }

}
