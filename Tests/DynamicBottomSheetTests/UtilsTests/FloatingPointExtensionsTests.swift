//
//  FloatingPointExtensionsTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet

@Suite("FloatingPoint Extensions Tests")
struct FloatingPointExtensionsTests {

  @Suite("isLess(than:eps:) Tests")
  struct IsLessTests {

    @Test("Value is clearly less than other minus epsilon")
    func valueClearlyLess() {
      let value: Double = 1.0
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(value.isLess(than: other, eps: eps))
    }

    @Test("Value is exactly equal to other minus epsilon")
    func valueEqualToOtherMinusEps() {
      let value: Double = 4.9
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(!value.isLess(than: other, eps: eps))
    }

    @Test("Value is greater than other minus epsilon")
    func valueGreaterThanOtherMinusEps() {
      let value: Double = 4.95
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(!value.isLess(than: other, eps: eps))
    }

    @Test("Works with Float type")
    func worksWithFloat() {
      let value: Float = 1.0
      let other: Float = 5.0
      let eps: Float = 0.1

      #expect(value.isLess(than: other, eps: eps))
    }

    @Test("Works with negative values")
    func worksWithNegativeValues() {
      let value: Double = -5.0
      let other: Double = -1.0
      let eps: Double = 0.1

      #expect(value.isLess(than: other, eps: eps))
    }
  }

  @Suite("isGreater(than:eps:) Tests")
  struct IsGreaterTests {

    @Test("Value is clearly greater than other plus epsilon")
    func valueClearlyGreater() {
      let value: Double = 6.0
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(value.isGreater(than: other, eps: eps))
    }

    @Test("Value is exactly equal to other plus epsilon")
    func valueEqualToOtherPlusEps() {
      let value: Double = 5.1
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(!value.isGreater(than: other, eps: eps))
    }

    @Test("Value is less than other plus epsilon")
    func valueLessThanOtherPlusEps() {
      let value: Double = 5.05
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(!value.isGreater(than: other, eps: eps))
    }

    @Test("Works with Float type")
    func worksWithFloat() {
      let value: Float = 6.0
      let other: Float = 5.0
      let eps: Float = 0.1

      #expect(value.isGreater(than: other, eps: eps))
    }

    @Test("Works with negative values")
    func worksWithNegativeValues() {
      let value: Double = -1.0
      let other: Double = -5.0
      let eps: Double = 0.1

      #expect(value.isGreater(than: other, eps: eps))
    }
  }

  @Suite("isEqual(to:eps:) Tests")
  struct IsEqualTests {

    @Test("Values are exactly equal")
    func valuesExactlyEqual() {
      let value: Double = 5.0
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(value.isEqual(to: other, eps: eps))
    }

    @Test("Values differ by less than epsilon")
    func valuesDifferByLessThanEpsilon() {
      let value: Double = 5.05
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(value.isEqual(to: other, eps: eps))
    }

    @Test("Values differ by exactly epsilon")
    func valuesDifferByExactlyEpsilon() {
      let value: Double = 5.1
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(value.isEqual(to: other, eps: eps))
    }

    @Test("Values differ by more than epsilon")
    func valuesDifferByMoreThanEpsilon() {
      let value: Double = 5.2
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(!value.isEqual(to: other, eps: eps))
    }

    @Test("Works with Float type")
    func worksWithFloat() {
      let value: Float = 5.05
      let other: Float = 5.0
      let eps: Float = 0.1

      #expect(value.isEqual(to: other, eps: eps))
    }

    @Test("Works when first value is smaller")
    func worksWhenFirstValueIsSmaller() {
      let value: Double = 4.95
      let other: Double = 5.0
      let eps: Double = 0.1

      #expect(value.isEqual(to: other, eps: eps))
    }

    @Test("Works with negative values")
    func worksWithNegativeValues() {
      let value: Double = -5.05
      let other: Double = -5.0
      let eps: Double = 0.1

      #expect(value.isEqual(to: other, eps: eps))
    }

    @Test("Works with very small epsilon")
    func worksWithVerySmallEpsilon() {
      let value: Double = 5.000001
      let other: Double = 5.0
      let eps: Double = 0.00001

      #expect(value.isEqual(to: other, eps: eps))
    }
  }

  @Suite("Edge Cases")
  struct EdgeCaseTests {

    @Test("Zero epsilon")
    func zeroEpsilon() {
      let value: Double = 5.0
      let other: Double = 5.0
      let eps: Double = 0.0

      #expect(value.isEqual(to: other, eps: eps))
      #expect(!value.isLess(than: other, eps: eps))
      #expect(!value.isGreater(than: other, eps: eps))
    }

    @Test("Negative epsilon")
    func negativeEpsilon() {
      let value: Double = 5.0
      let other: Double = 5.0
      let eps: Double = -0.1

      #expect(!value.isEqual(to: other, eps: eps))
    }

    @Test("Very large epsilon")
    func veryLargeEpsilon() {
      let value: Double = 1.0
      let other: Double = 100.0
      let eps: Double = 1000.0

      #expect(value.isEqual(to: other, eps: eps))
    }
  }
}
