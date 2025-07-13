//
//  ClosedRangeTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
import Foundation
@testable import DynamicBottomSheet

@Suite("ClosedRange+Contains with Epsilon Tests")
struct ClosedRangeContainsEpsilonTests {

  @Test("Basic containment with positive epsilon")
  func testBasicContainmentWithPositiveEpsilon() {
    let range: ClosedRange = 1.0...3.0

    #expect(range.contains(0.95, eps: 0.1) == true)
    #expect(range.contains(3.1, eps: 0.1) == true)
    #expect(range.contains(3.2, eps: 0.1) == false)
    #expect(range.contains(0.8, eps: 0.1) == false)
  }

  @Test("Basic containment with negative epsilon")
  func testBasicContainmentWithNegativeEpsilon() {
    let range: ClosedRange = 1.0...3.0

    #expect(range.contains(3.0, eps: -0.1) == false)
    #expect(range.contains(1.0, eps: -0.1) == false)
    #expect(range.contains(1.5, eps: -0.1) == true)
    #expect(range.contains(2.5, eps: -0.1) == true)
    #expect(range.contains(1.05, eps: -0.1) == false)
    #expect(range.contains(2.95, eps: -0.1) == false)
  }

  @Test("Zero epsilon behaves like standard contains")
  func testZeroEpsilon() {
    let range: ClosedRange = 1.0...3.0

    #expect(range.contains(1.0, eps: 0.0) == range.contains(1.0))
    #expect(range.contains(3.0, eps: 0.0) == range.contains(3.0))
    #expect(range.contains(2.0, eps: 0.0) == range.contains(2.0))
    #expect(range.contains(0.9, eps: 0.0) == range.contains(0.9))
    #expect(range.contains(3.1, eps: 0.0) == range.contains(3.1))
  }

  @Test("Boundary conditions with positive epsilon")
  func testBoundaryConditionsPositiveEpsilon() {
    let range: ClosedRange = 1.0...3.0
    let eps = 0.5

    // Exact boundary values
    #expect(range.contains(0.5, eps: eps) == true)  // lowerBound - eps
    #expect(range.contains(3.5, eps: eps) == true)  // upperBound + eps

    // Just outside boundaries
    #expect(range.contains(0.49, eps: eps) == false)
    #expect(range.contains(3.51, eps: eps) == false)
  }

  @Test("Boundary conditions with negative epsilon")
  func testBoundaryConditionsNegativeEpsilon() {
    let range: ClosedRange = 1.0...3.0
    let eps = -0.5

    // Exact boundary values
    #expect(range.contains(1.5, eps: eps) == true)   // lowerBound - eps
    #expect(range.contains(2.5, eps: eps) == true)   // upperBound + eps

    // Just outside boundaries
    #expect(range.contains(1.49, eps: eps) == false)
    #expect(range.contains(2.51, eps: eps) == false)
  }

  @Test("Single point range")
  func testSinglePointRange() {
    let range: ClosedRange = 2.0...2.0

    #expect(range.contains(2.0, eps: 0.0) == true)
    #expect(range.contains(1.9, eps: 0.1) == true)
    #expect(range.contains(2.1, eps: 0.1) == true)
    #expect(range.contains(1.8, eps: 0.1) == false)
    #expect(range.contains(2.2, eps: 0.1) == false)

    // Negative epsilon contracts the range
    #expect(range.contains(2.0, eps: -0.1) == false)
  }

  @Test("Large epsilon values")
  func testLargeEpsilonValues() {
    let range: ClosedRange = 1.0...3.0
    let largeEps = 100.0

    #expect(range.contains(-50.0, eps: largeEps) == true)
    #expect(range.contains(50.0, eps: largeEps) == true)
    #expect(range.contains(-101.0, eps: largeEps) == false)
    #expect(range.contains(103.1, eps: largeEps) == false)
  }

  @Test("Very small epsilon values")
  func testVerySmallEpsilonValues() {
    let range: ClosedRange = 1.0...3.0
    let smallEps = 1e-10

    #expect(range.contains(1.0 - smallEps/2, eps: smallEps) == true)
    #expect(range.contains(3.0 + smallEps/2, eps: smallEps) == true)
    #expect(range.contains(1.0 - smallEps*2, eps: smallEps) == false)
    #expect(range.contains(3.0 + smallEps*2, eps: smallEps) == false)
  }

  @Test("Negative range values")
  func testNegativeRangeValues() {
    let range: ClosedRange = -5.0...(-2.0)

    #expect(range.contains(-5.1, eps: 0.2) == true)
    #expect(range.contains(-1.9, eps: 0.2) == true)
    #expect(range.contains(-5.3, eps: 0.2) == false)
    #expect(range.contains(-1.7, eps: 0.2) == false)
  }

  @Test("Float precision")
  func testFloatPrecision() {
    let range: ClosedRange<Float> = 1.0...3.0

    #expect(range.contains(0.95, eps: 0.1) == true)
    #expect(range.contains(3.1, eps: 0.1) == true)
    #expect(range.contains(3.2, eps: 0.1) == false)
  }

  @Test("CGFloat compatibility")
  func testCGFloatCompatibility() {
    let range: ClosedRange<CGFloat> = 1.0...3.0

    #expect(range.contains(0.95, eps: 0.1) == true)
    #expect(range.contains(3.1, eps: 0.1) == true)
    #expect(range.contains(3.2, eps: 0.1) == false)
  }

  @Test("Edge case: epsilon larger than range")
  func testEpsilonLargerThanRange() {
    let range: ClosedRange = 2.0...2.1  // Very small range
    let largeEps = 1.0

    // With large positive epsilon, range becomes very wide
    #expect(range.contains(1.0, eps: largeEps) == true)
    #expect(range.contains(3.1, eps: largeEps) == true)

    // With large negative epsilon, range becomes invalid (contracted beyond bounds)
    #expect(range.contains(2.05, eps: -largeEps) == false)
  }
}
