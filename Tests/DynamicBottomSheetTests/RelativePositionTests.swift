//
//  RelativePositionTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet
import UIKit

@Suite("Test RelativePosition calculation and moving")
@MainActor
struct RelativePositionTests {

  let bottomSheet = DynamicBottomSheet()

  init() {
    bottomSheet.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    bottomSheet.layoutSubviews()
  }

  @Test
  func didLayoutSubviews() {
    #expect(bottomSheet.didLayoutSubviews)
  }

  @Test
  func initialPosition() {
    #expect(bottomSheet.y == 1000)
  }

  @Test
  func topPosition() {
    bottomSheet.detents.positions = [.top()]

    #expect(bottomSheet.y == 1000)

    bottomSheet.detents.move(to: .top(), animated: false)
    #expect(bottomSheet.y == 0)
  }

  @Test
  func middlePosition() {
    bottomSheet.detents.positions = [.middle()]

    #expect(bottomSheet.y == 1000)

    bottomSheet.detents.move(to: .middle(), animated: false)
    #expect(bottomSheet.y == 500)
  }

  @Test
  func bottomPosition() {
    bottomSheet.detents.positions = [.bottom()]

    #expect(bottomSheet.y == 1000)

    bottomSheet.detents.move(to: .bottom(), animated: false)
    #expect(bottomSheet.y == 1000)
  }

  @Test
  func topPositionWithArg() {
    let position1: RelativePosition = .top()
    let position2: RelativePosition = .top(ignoresSafeArea: false)

    #expect(bottomSheet.detents.y(for: position1) == 0)
    #expect(bottomSheet.detents.y(for: position2) == 0)

    bottomSheet.detents.move(to: position1, animated: false)
    #expect(bottomSheet.y == 0)

    bottomSheet.detents.move(to: position2, animated: false)
    #expect(bottomSheet.y == 0)
  }

  @Test
  func fromTopPositionWithArg() {
    let position1: RelativePosition = .fromTop(100)
    let position2: RelativePosition = .fromTop(0)
    let position3: RelativePosition = .fromTop(-100)

    #expect(bottomSheet.detents.y(for: position1) == 100)
    #expect(bottomSheet.detents.y(for: position2) == 0)
    #expect(bottomSheet.detents.y(for: position3) == -100)

    bottomSheet.detents.move(to: position1, animated: false)
    #expect(bottomSheet.y == 100)

    bottomSheet.detents.move(to: position2, animated: false)
    #expect(bottomSheet.y == 0)

    bottomSheet.detents.move(to: position3, animated: false)
    #expect(bottomSheet.y == -100)
  }

  @Test
  func middlePositionWithArg() {
    let position1: RelativePosition = .middle()
    let position2: RelativePosition = .middle(offset: -100)
    let position3: RelativePosition = .middle(offset: 100)

    #expect(bottomSheet.detents.y(for: position1) == 500)
    #expect(bottomSheet.detents.y(for: position2) == 400)
    #expect(bottomSheet.detents.y(for: position3) == 600)

    bottomSheet.detents.move(to: position1, animated: false)
    #expect(bottomSheet.y == 500)

    bottomSheet.detents.move(to: position2, animated: false)
    #expect(bottomSheet.y == 400)

    bottomSheet.detents.move(to: position3, animated: false)
    #expect(bottomSheet.y == 600)
  }

  @Test
  func bottomPositionWithArg() {
    let position1: RelativePosition = .bottom()
    let position2: RelativePosition = .bottom(ignoresSafeArea: false)

    #expect(bottomSheet.detents.y(for: position1) == 1000)
    #expect(bottomSheet.detents.y(for: position2) == 1000)

    bottomSheet.detents.move(to: position1, animated: false)
    #expect(bottomSheet.y == 1000)

    bottomSheet.detents.move(to: position2, animated: false)
    #expect(bottomSheet.y == 1000)
  }

  @Test
  func fromBottomPositionWithArg() {
    let position1: RelativePosition = .fromBottom(0)
    let position2: RelativePosition = .fromBottom(100)
    let position3: RelativePosition = .fromBottom(-100)

    #expect(bottomSheet.detents.y(for: position1) == 1000)
    #expect(bottomSheet.detents.y(for: position2) == 900)
    #expect(bottomSheet.detents.y(for: position3) == 1100)

    bottomSheet.detents.move(to: position1, animated: false)
    #expect(bottomSheet.y == 1000)

    bottomSheet.detents.move(to: position2, animated: false)
    #expect(bottomSheet.y == 900)

    bottomSheet.detents.move(to: position3, animated: false)
    #expect(bottomSheet.y == 1000)
  }

  @Test
  func hidden() {
    let hiddenPosition: RelativePosition = .hidden
    #expect(bottomSheet.detents.y(for: hiddenPosition) == 1000)
    bottomSheet.detents.move(to: hiddenPosition, animated: false)
    #expect(bottomSheet.y == 1000)
  }

}
