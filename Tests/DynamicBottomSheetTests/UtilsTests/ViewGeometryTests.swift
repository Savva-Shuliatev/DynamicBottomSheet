//
//  ViewGeometryTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
import UIKit
@testable import DynamicBottomSheet

@Suite("ViewGeometry Tests")
struct ViewGeometryTests {

  @Test("Init with parameters creates ViewGeometry with correct values")
  func testInitWithParameters() {
    let frame = CGRect(x: 10, y: 20, width: 100, height: 200)
    let bounds = CGRect(x: 0, y: 0, width: 100, height: 200)
    let safeAreaInsets = UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)

    let viewGeometry = ViewGeometry(
      frame: frame,
      bounds: bounds,
      safeAreaInsets: safeAreaInsets
    )

    #expect(viewGeometry.frame == frame)
    #expect(viewGeometry.bounds == bounds)
    #expect(viewGeometry.safeAreaInsets == safeAreaInsets)
  }

  @Test("Zero static property has correct zero values")
  func testZeroStaticProperty() {
    let zeroGeometry = ViewGeometry.zero

    #expect(zeroGeometry.frame == .zero)
    #expect(zeroGeometry.bounds == .zero)
    #expect(zeroGeometry.safeAreaInsets == .zero)
  }

  @Test("Init with UIView creates ViewGeometry with view properties")
  @MainActor
  func testInitWithUIView() {
    let view = UIView()
    let expectedFrame = CGRect(x: 50, y: 100, width: 200, height: 300)
    let expectedBounds = CGRect(x: 0, y: 0, width: 200, height: 300)
    let expectedSafeAreaInsets = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)

    view.frame = expectedFrame
    view.bounds = expectedBounds

    let mockView = MockUIView()
    mockView.frame = expectedFrame
    mockView.bounds = expectedBounds
    mockView.mockSafeAreaInsets = expectedSafeAreaInsets

    let viewGeometry = ViewGeometry(of: mockView)

    #expect(viewGeometry.frame == expectedFrame)
    #expect(viewGeometry.bounds == expectedBounds)
    #expect(viewGeometry.safeAreaInsets == expectedSafeAreaInsets)
  }

  @Test("ViewGeometry conforms to Equatable")
  func testEquatable() {
    let frame = CGRect(x: 10, y: 20, width: 100, height: 200)
    let bounds = CGRect(x: 0, y: 0, width: 100, height: 200)
    let safeAreaInsets = UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)

    let geometry1 = ViewGeometry(
      frame: frame,
      bounds: bounds,
      safeAreaInsets: safeAreaInsets
    )

    let geometry2 = ViewGeometry(
      frame: frame,
      bounds: bounds,
      safeAreaInsets: safeAreaInsets
    )

    let geometry3 = ViewGeometry(
      frame: CGRect(x: 0, y: 0, width: 50, height: 50),
      bounds: bounds,
      safeAreaInsets: safeAreaInsets
    )

    #expect(geometry1 == geometry2)
    #expect(geometry1 != geometry3)
  }

  @Test("ViewGeometry with different frames are not equal")
  func testInequalityWithDifferentFrames() {
    let bounds = CGRect(x: 0, y: 0, width: 100, height: 200)
    let safeAreaInsets = UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)

    let geometry1 = ViewGeometry(
      frame: CGRect(x: 10, y: 20, width: 100, height: 200),
      bounds: bounds,
      safeAreaInsets: safeAreaInsets
    )

    let geometry2 = ViewGeometry(
      frame: CGRect(x: 0, y: 0, width: 100, height: 200),
      bounds: bounds,
      safeAreaInsets: safeAreaInsets
    )

    #expect(geometry1 != geometry2)
  }

  @Test("ViewGeometry with different bounds are not equal")
  func testInequalityWithDifferentBounds() {
    let frame = CGRect(x: 10, y: 20, width: 100, height: 200)
    let safeAreaInsets = UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)

    let geometry1 = ViewGeometry(
      frame: frame,
      bounds: CGRect(x: 0, y: 0, width: 100, height: 200),
      safeAreaInsets: safeAreaInsets
    )

    let geometry2 = ViewGeometry(
      frame: frame,
      bounds: CGRect(x: 5, y: 5, width: 100, height: 200),
      safeAreaInsets: safeAreaInsets
    )

    #expect(geometry1 != geometry2)
  }

  @Test("ViewGeometry with different safeAreaInsets are not equal")
  func testInequalityWithDifferentSafeAreaInsets() {
    let frame = CGRect(x: 10, y: 20, width: 100, height: 200)
    let bounds = CGRect(x: 0, y: 0, width: 100, height: 200)

    let geometry1 = ViewGeometry(
      frame: frame,
      bounds: bounds,
      safeAreaInsets: UIEdgeInsets(top: 44, left: 0, bottom: 34, right: 0)
    )

    let geometry2 = ViewGeometry(
      frame: frame,
      bounds: bounds,
      safeAreaInsets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    )

    #expect(geometry1 != geometry2)
  }
}

private class MockUIView: UIView {
  var mockSafeAreaInsets: UIEdgeInsets = .zero

  override var safeAreaInsets: UIEdgeInsets {
    return mockSafeAreaInsets
  }
}
