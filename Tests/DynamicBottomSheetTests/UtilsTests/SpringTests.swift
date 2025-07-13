//
//  SpringTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation
import CoreGraphics
import Testing
@testable import DynamicBottomSheet

struct SpringTests {

  @Test("Spring initialization")
  func testSpringInitialization() {
    let spring = Spring(mass: 2.0, stiffness: 100.0, dampingRatio: 0.5)

    #expect(spring.mass == 2.0)
    #expect(spring.stiffness == 100.0)
    #expect(spring.dampingRatio == 0.5)
  }

  @Test("Spring default configuration")
  func testSpringDefault() {
    let spring = Spring.default

    #expect(spring.mass == 1.0)
    #expect(spring.stiffness == 250.0)
    #expect(spring.dampingRatio == 0.8)
  }

  @Test("Spring equality")
  func testSpringEquality() {
    let spring1 = Spring(mass: 1.0, stiffness: 250.0, dampingRatio: 0.8)
    let spring2 = Spring(mass: 1.0, stiffness: 250.0, dampingRatio: 0.8)
    let spring3 = Spring(mass: 2.0, stiffness: 250.0, dampingRatio: 0.8)

    #expect(spring1 == spring2)
    #expect(spring1 != spring3)
  }

  @Test("Spring computed properties")
  func testSpringComputedProperties() {
    let spring = Spring(mass: 4.0, stiffness: 100.0, dampingRatio: 0.5)

    // damping = 2 * dampingRatio * sqrt(mass * stiffness)
    let expectedDamping = 2.0 * 0.5 * sqrt(4.0 * 100.0)
    #expect(abs(spring.damping - expectedDamping) < 0.001)

    // beta = damping / (2 * mass)
    let expectedBeta = expectedDamping / (2.0 * 4.0)
    #expect(abs(spring.beta - expectedBeta) < 0.001)

    // dampedNaturalFrequency = sqrt(stiffness / mass) * sqrt(1 - dampingRatio^2)
    let expectedDampedFreq = sqrt(100.0 / 4.0) * sqrt(1.0 - 0.5 * 0.5)
    #expect(abs(spring.dampedNaturalFrequency - expectedDampedFreq) < 0.001)
  }

  @Test("Spring with zero damping ratio")
  func testSpringZeroDamping() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.0)

    #expect(spring.damping == 0.0)
    #expect(spring.beta == 0.0)
    #expect(abs(spring.dampedNaturalFrequency - 10.0) < 0.001) // sqrt(100/1) = 10
  }

  @Test("Spring with critical damping")
  func testSpringCriticalDamping() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 1.0)

    #expect(abs(spring.damping - 20.0) < 0.001) // 2 * 1 * sqrt(1 * 100) = 20
    #expect(abs(spring.beta - 10.0) < 0.001) // 20 / (2 * 1) = 10
    #expect(spring.dampedNaturalFrequency == 0.0) // sqrt(1 - 1^2) = 0
  }
}

struct SpringTimingParametersTests {

  @Test("Underdamped spring timing parameters initialization")
  func testUnderdampedInitialization() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.5)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 5.0,
      threshold: 0.1
    )

    #expect(params.spring == spring)
    #expect(params.displacement == 10.0)
    #expect(params.initialVelocity == 5.0)
    #expect(params.threshold == 0.1)
  }

  @Test("Critically damped spring timing parameters initialization")
  func testCriticallyDampedInitialization() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 1.0)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 5.0,
      threshold: 0.1
    )

    #expect(params.spring == spring)
    #expect(params.displacement == 10.0)
    #expect(params.initialVelocity == 5.0)
    #expect(params.threshold == 0.1)
  }

  @Test("Zero displacement and velocity results in zero duration")
  func testZeroDisplacementAndVelocity() {
    let spring = Spring.default
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 0.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    #expect(params.duration == 0.0)
  }

  @Test("Underdamped spring value calculation at t=0")
  func testUnderdampedValueAtZero() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.5)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    let initialValue = params.value(at: 0.0)
    #expect(abs(initialValue - 10.0) < 0.001)
  }

  @Test("Critically damped spring value calculation at t=0")
  func testCriticallyDampedValueAtZero() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 1.0)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    let initialValue = params.value(at: 0.0)
    #expect(abs(initialValue - 10.0) < 0.001)
  }

  @Test("Underdamped spring amplitude decreases over time")
  func testUnderdampedAmplitudeDecreases() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.3)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    let amplitude0 = params.amplitude(at: 0.0)
    let amplitude1 = params.amplitude(at: 0.1)
    let amplitude2 = params.amplitude(at: 0.2)

    #expect(amplitude0 > amplitude1)
    #expect(amplitude1 > amplitude2)
    #expect(amplitude2 > 0.0)
  }

  @Test("Critically damped spring amplitude calculation")
  func testCriticallyDampedAmplitude() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 1.0)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    let amplitude0 = params.amplitude(at: 0.0)
    let amplitude1 = params.amplitude(at: 0.1)

    #expect(amplitude0 == 10.0)
    #expect(amplitude1 < amplitude0)
    #expect(amplitude1 > 0.0)
  }

  @Test("Spring duration is positive for non-zero displacement")
  func testPositiveDuration() {
    let spring = Spring.default
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 5.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    #expect(params.duration > 0.0)
  }

  @Test("Spring duration is positive for non-zero velocity")
  func testPositiveDurationWithVelocity() {
    let spring = Spring.default
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 0.0,
      initialVelocity: 10.0,
      threshold: 0.1
    )

    #expect(params.duration > 0.0)
  }

  @Test("Spring converges to zero at duration time")
  func testConvergenceAtDuration() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.8)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )

    let finalValue = abs(params.value(at: params.duration))
    #expect(finalValue <= params.threshold)
  }

  @Test("Different thresholds affect duration")
  func testThresholdAffectsDuration() {
    let spring = Spring.default
    let params1 = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.1
    )
    let params2 = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.01
    )

    #expect(params2.duration > params1.duration)
  }

}

struct SpringBehaviorTests {

  @Test("Underdamped spring oscillation")
  func testUnderdampedOscillation() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.2)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.01
    )

    // Should oscillate around zero
    var crossesZero = false
    for i in 1..<100 {
      let t = TimeInterval(i) * 0.01
      let value = params.value(at: t)
      if abs(value) < 0.1 {
        crossesZero = true
        break
      }
    }

    #expect(crossesZero)
  }

  @Test("Critically damped spring no oscillation")
  func testCriticallyDampedNoOscillation() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 1.0)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 10.0,
      initialVelocity: 0.0,
      threshold: 0.01
    )

    // Should not cross zero (no oscillation)
    var previousValue = params.value(at: 0.0)
    var crossesZero = false

    for i in 1..<100 {
      let t = TimeInterval(i) * 0.01
      let value = params.value(at: t)
      if (previousValue > 0 && value < 0) || (previousValue < 0 && value > 0) {
        crossesZero = true
        break
      }
      previousValue = value
    }

    #expect(!crossesZero)
  }

  @Test("Spring with initial velocity")
  func testSpringWithInitialVelocity() {
    let spring = Spring(mass: 1.0, stiffness: 100.0, dampingRatio: 0.5)
    let params = SpringTimingParameters(
      spring: spring,
      displacement: 0.0,
      initialVelocity: 50.0,
      threshold: 0.1
    )

    let initialValue = params.value(at: 0.0)
    let nearInitialValue = params.value(at: 0.001)

    #expect(abs(initialValue) < 0.001) // Should start at zero
    #expect(nearInitialValue > initialValue) // Should move in positive direction
  }
}
