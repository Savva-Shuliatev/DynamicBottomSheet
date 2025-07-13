//
//  FloatingPointProjectionTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet

struct FloatingPointProjectionTests {

  // MARK: - Static project method tests

  @Test("Static project method with valid deceleration rates")
  func testStaticProjectWithValidDecelerationRates() {
    // Test with Double
    let doubleResult = Double.project(initialVelocity: 100.0, decelerationRate: 0.5)
    #expect(doubleResult == 100.0)

    // Test with Float
    let floatResult = Float.project(initialVelocity: 50.0, decelerationRate: 0.8)
    #expect(abs(floatResult - 200.0) < 0.001)

    // Test with zero initial velocity
    let zeroVelocityResult = Double.project(initialVelocity: 0.0, decelerationRate: 0.5)
    #expect(zeroVelocityResult == 0.0)

    // Test with very small deceleration rate
    let smallDecelerationResult = Double.project(initialVelocity: 10.0, decelerationRate: 0.01)
    #expect(abs(smallDecelerationResult - 0.101) < 0.001)
  }

  @Test("Static project method with edge case deceleration rate of 0")
  func testStaticProjectWithZeroDecelerationRate() {
    let result = Double.project(initialVelocity: 100.0, decelerationRate: 0.0)
    #expect(result == 0.0)
  }

  @Test("Static project method with negative initial velocity")
  func testStaticProjectWithNegativeInitialVelocity() {
    let result = Double.project(initialVelocity: -50.0, decelerationRate: 0.5)
    #expect(result == -50.0)
  }

  // MARK: - Instance project method tests

  @Test("Instance project method with valid parameters")
  func testInstanceProjectWithValidParameters() {
    let initialPosition: Double = 10.0
    let result = initialPosition.project(initialVelocity: 100.0, decelerationRate: 0.5)
    #expect(result == 110.0) // initialPosition + projected distance

    let floatPosition: Float = 5.0
    let floatResult = floatPosition.project(initialVelocity: 40.0, decelerationRate: 0.75)
    #expect(abs(floatResult - 125.0) < 0.001) // 5.0 + 120.0
  }

  @Test("Instance project method with zero initial position")
  func testInstanceProjectWithZeroInitialPosition() {
    let initialPosition: Double = 0.0
    let result = initialPosition.project(initialVelocity: 50.0, decelerationRate: 0.6)
    #expect(abs(result - 75.0) < 0.001) // 0.0 + 75.0
  }

  @Test("Instance project method with negative initial position")
  func testInstanceProjectWithNegativeInitialPosition() {
    let initialPosition: Double = -20.0
    let result = initialPosition.project(initialVelocity: 100.0, decelerationRate: 0.5)
    #expect(result == 80.0) // -20.0 + 100.0
  }

  // MARK: - Mathematical accuracy tests

  @Test("Mathematical formula verification")
  func testMathematicalFormulaAccuracy() {
    // Test the formula: initialVelocity * decelerationRate / (1 - decelerationRate)
    let velocity: Double = 120.0
    let rate: Double = 0.8
    let expectedResult = velocity * rate / (1 - rate) // 120 * 0.8 / 0.2 = 480

    let actualResult = Double.project(initialVelocity: velocity, decelerationRate: rate)
    #expect(abs(actualResult - expectedResult) < 0.000001)
  }

  @Test("Precision test with very small numbers")
  func testPrecisionWithSmallNumbers() {
    let result = Double.project(initialVelocity: 0.001, decelerationRate: 0.999)
    // Expected: 0.001 * 0.999 / (1 - 0.999) = 0.001 * 0.999 / 0.001 = 0.999
    #expect(abs(result - 0.999) < 0.000001)
  }

  @Test("Different floating point types consistency")
  func testFloatingPointTypesConsistency() {
    let velocity = 100.0
    let rate = 0.5

    let doubleResult = Double.project(initialVelocity: velocity, decelerationRate: rate)
    let floatResult = Float.project(initialVelocity: Float(velocity), decelerationRate: Float(rate))

    // Results should be equivalent within Float precision
    #expect(abs(Double(floatResult) - doubleResult) < 0.0001)
  }
}
