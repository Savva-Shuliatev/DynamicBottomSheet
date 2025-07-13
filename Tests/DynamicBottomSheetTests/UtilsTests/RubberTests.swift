//
//  RubberTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import CoreGraphics
import Testing
@testable import DynamicBottomSheet

extension CGFloat {
  func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
    return Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
  }
}

@Suite("Rubber Tests")
struct RubberTests {

  @Suite("bandClamp with dim parameter")
  struct BandClampDimTests {

    @Test("returns zero for zero input")
    func testZeroInput() {
      let result = Rubber.bandClamp(0, dim: 100)
      #expect(result == 0)
    }

    @Test("returns value less than input for positive values")
    func testPositiveValues() {
      let testCases: [(input: CGFloat, dim: CGFloat)] = [
        (50, 100),
        (25, 50),
        (100, 200),
        (10, 20)
      ]

      for testCase in testCases {
        let result = Rubber.bandClamp(testCase.input, dim: testCase.dim)
        #expect(result < testCase.input)
        #expect(result >= 0)
      }
    }

    @Test("approaches dim asymptotically for large inputs")
    func testAsymptoticBehavior() {
      let dim: CGFloat = 100
      let largeValue: CGFloat = 10000
      let result = Rubber.bandClamp(largeValue, dim: dim)

      #expect(result < dim)
      #expect(result > dim * 0.9)
    }

    @Test("different coefficients produce different results")
    func testDifferentCoefficients() {
      let input: CGFloat = 50
      let dim: CGFloat = 100

      let result1 = Rubber.bandClamp(input, coeff: 0.3, dim: dim)
      let result2 = Rubber.bandClamp(input, coeff: 0.8, dim: dim)

      #expect(result1 != result2)
    }

    @Test("small dim values work correctly")
    func testSmallDim() {
      let result = Rubber.bandClamp(5, dim: 1)
      #expect(result > 0)
      #expect(result < 1)
    }
  }

  @Suite("bandClamp with limits parameter")
  struct BandClampLimitsTests {

    @Test("returns input when within limits")
    func testValueWithinLimits() {
      let limits: ClosedRange<CGFloat> = 0...100
      let input: CGFloat = 50

      let result = Rubber.bandClamp(input, limits: limits)
      #expect(result == input)
    }

    @Test("handles overflow above upper bound")
    func testOverflowAboveUpperBound() {
      let limits: ClosedRange<CGFloat> = 0...100
      let input: CGFloat = 150

      let result = Rubber.bandClamp(input, limits: limits)
      #expect(result > limits.upperBound)
      #expect(result < input)
    }

    @Test("handles overflow below lower bound")
    func testOverflowBelowLowerBound() {
      let limits: ClosedRange<CGFloat> = 50...100
      let input: CGFloat = 20

      let result = Rubber.bandClamp(input, limits: limits)
      #expect(result < limits.lowerBound)
      #expect(result > input)
    }

    @Test("extreme overflow values are bounded")
    func testExtremeOverflow() {
      let limits: ClosedRange<CGFloat> = 0...100

      let extremeHigh: CGFloat = 10000
      let resultHigh = Rubber.bandClamp(extremeHigh, limits: limits)
      #expect(resultHigh > limits.upperBound)
      #expect(resultHigh < extremeHigh)

      let extremeLow: CGFloat = -10000
      let resultLow = Rubber.bandClamp(extremeLow, limits: limits)
      #expect(resultLow < limits.lowerBound)
      #expect(resultLow > extremeLow)
    }

    @Test("different coefficients affect overflow behavior")
    func testCoefficientsWithLimits() {
      let limits: ClosedRange<CGFloat> = 0...100
      let input: CGFloat = 150

      let result1 = Rubber.bandClamp(input, coeff: 0.3, limits: limits)
      let result2 = Rubber.bandClamp(input, coeff: 0.8, limits: limits)

      #expect(result1 != result2)
      #expect(result1 > limits.upperBound)
      #expect(result2 > limits.upperBound)
    }

    @Test("negative limits work correctly")
    func testNegativeLimits() {
      let limits: ClosedRange<CGFloat> = -100...(-50)
      let input: CGFloat = -75

      let result = Rubber.bandClamp(input, limits: limits)
      #expect(result == input)

      let overflowInput: CGFloat = -30
      let overflowResult = Rubber.bandClamp(overflowInput, limits: limits)
      #expect(overflowResult > limits.upperBound)
      #expect(overflowResult < overflowInput)
    }

    @Test("zero-width limits")
    func testZeroWidthLimits() {
      let limits: ClosedRange<CGFloat> = 50...50
      let input: CGFloat = 75

      let result = Rubber.bandClamp(input, limits: limits)
      #expect(result == limits.upperBound)
    }
  }

  @Suite("Edge Cases")
  struct EdgeCaseTests {

    @Test("very small positive values")
    func testVerySmallValues() {
      let result = Rubber.bandClamp(0.001, dim: 1)
      #expect(result > 0)
      #expect(result < 0.001)
    }

    @Test("coefficient edge cases")
    func testCoefficientEdgeCases() {
      let input: CGFloat = 50
      let dim: CGFloat = 100

      let smallCoeff = Rubber.bandClamp(input, coeff: 0.01, dim: dim)
      #expect(smallCoeff > 0)
      #expect(smallCoeff < input)

      let largeCoeff = Rubber.bandClamp(input, coeff: 2.0, dim: dim)
      #expect(largeCoeff > 0)
      #expect(largeCoeff == input)
    }

    @Test("consistency between both methods at boundaries")
    func testConsistencyAtBoundaries() {
      let limits: ClosedRange<CGFloat> = 0...100
      let boundaryValue = limits.upperBound

      let result = Rubber.bandClamp(boundaryValue, limits: limits)
      #expect(result == boundaryValue)
    }
  }
}
