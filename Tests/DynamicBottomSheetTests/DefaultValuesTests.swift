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

@Suite("Default values Tests") @MainActor
struct DefaultValuesTests {

  @Test
  func defaultValues() {
    let bottomSheet = DynamicBottomSheet()

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
    #expect(bottomSheet.bounces == DynamicBottomSheet.Values.default.bounces)
  }

  @Test
  func realizationValues() {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.anchors.isEmpty)
    #expect(!bottomSheet.didLayoutSubviews)
  }

  @Test
  func equalDefaultValues() {
    expectingDefaultValues(values: .default)

    let mockValues = mockValues()
    DynamicBottomSheet.Values.default = mockValues
    expectingDefaultValues(values: mockValues)
  }

}

extension DefaultValuesTests {
  func expectingDefaultValues(values: DynamicBottomSheet.Values) {
    let bottomSheet = DynamicBottomSheet()
    #expect(bottomSheet.bounces == values.bounces)
    #expect(bottomSheet.bouncesFactor == values.bouncesFactor)
    #expect(bottomSheet.viewIgnoresTopSafeArea == values.viewIgnoresTopSafeArea)
    #expect(bottomSheet.bottomBar.viewIgnoresBottomBarHeight == values.viewIgnoresBottomBarHeight)
    #expect(bottomSheet.viewIgnoresBottomSafeArea == values.viewIgnoresBottomSafeArea)
    #expect(bottomSheet.prefersGrabberVisible == values.prefersGrabberVisible)
    #expect(bottomSheet.cornerRadius == values.cornerRadius)
    #expect(bottomSheet.shadowColor == values.shadowColor)
    #expect(bottomSheet.shadowOpacity == values.shadowOpacity)
    #expect(bottomSheet.shadowOffset == values.shadowOffset)
    #expect(bottomSheet.shadowRadius == values.shadowRadius)
    #expect(bottomSheet.shadowPath == values.shadowPath)
    #expect(bottomSheet.bottomBar.isHidden == values.bottomBarIsHidden)
    #expect(bottomSheet.bottomBar.height == values.bottomBarHeight)
    #expect(bottomSheet.animationParameters == values.animationParameters)
    #expect(bottomSheet.detents.positions == values.detentsValues.positions)
    #expect(bottomSheet.detents.availablePositions == values.detentsValues.availablePositions)
    #expect(bottomSheet.bottomBar.connectedPosition == values.detentsValues.bottomBarConnectedPosition)
  }

  func mockValues() -> DynamicBottomSheet.Values {
    var values = DynamicBottomSheet.Values.default
    values.bounces.toggle()
    values.bouncesFactor = 0.5
    values.viewIgnoresTopSafeArea.toggle()
    values.viewIgnoresBottomBarHeight.toggle()
    values.viewIgnoresBottomSafeArea.toggle()
    values.prefersGrabberVisible.toggle()
    values.cornerRadius = 0
    values.shadowColor = UIColor.black.cgColor
    values.shadowOpacity = 0
    values.shadowOffset = CGSize(width: 1, height: 1)
    values.shadowRadius += 10
    values.shadowPath = nil
    values.bottomBarIsHidden.toggle()
    values.bottomBarHeight += 10
    values.animationParameters = .spring(mass: 0.1, stiffness: 0.1, dampingRatio: 0.1)
    values.detentsValues.positions = [.hidden]
    values.detentsValues.availablePositions = [.hidden]
    values.detentsValues.bottomBarConnectedPosition = .hidden
    return values
  }
}


