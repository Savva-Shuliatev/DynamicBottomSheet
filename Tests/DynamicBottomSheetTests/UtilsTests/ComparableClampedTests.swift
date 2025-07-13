//
//  ComparableClampedTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet

@Suite("Comparable clamped(to:) Extension Tests")
struct ComparableClampedTests {

  @Test("Value below range gets clamped to lower bound")
  func valueBelowRangeClampedToLowerBound() {
    let value = 5
    let result = value.clamped(to: 10...20)
    #expect(result == 10)
  }

  @Test("Value above range gets clamped to upper bound")
  func valueAboveRangeClampedToUpperBound() {
    let value = 25
    let result = value.clamped(to: 10...20)
    #expect(result == 20)
  }

  @Test("Value within range remains unchanged")
  func valueWithinRangeRemainsUnchanged() {
    let value = 15
    let result = value.clamped(to: 10...20)
    #expect(result == 15)
  }

  @Test("Value equal to lower bound remains unchanged")
  func valueEqualToLowerBoundRemainsUnchanged() {
    let value = 10
    let result = value.clamped(to: 10...20)
    #expect(result == 10)
  }

  @Test("Value equal to upper bound remains unchanged")
  func valueEqualToUpperBoundRemainsUnchanged() {
    let value = 20
    let result = value.clamped(to: 10...20)
    #expect(result == 20)
  }

  @Test("Single value range works correctly")
  func singleValueRangeWorksCorrectly() {
    let value1 = 5
    let value2 = 15
    let value3 = 10

    #expect(value1.clamped(to: 10...10) == 10)
    #expect(value2.clamped(to: 10...10) == 10)
    #expect(value3.clamped(to: 10...10) == 10)
  }

  @Test("Works with Double values")
  func worksWithDoubleValues() {
    let progress = 1.2
    let result = progress.clamped(to: 0.0...1.0)
    #expect(result == 1.0)

    let negativeProgress = -0.5
    let result2 = negativeProgress.clamped(to: 0.0...1.0)
    #expect(result2 == 0.0)

    let validProgress = 0.7
    let result3 = validProgress.clamped(to: 0.0...1.0)
    #expect(result3 == 0.7)
  }

  @Test("Works with negative ranges")
  func worksWithNegativeRanges() {
    let value = -15
    let result = value.clamped(to: -10...(-5))
    #expect(result == -10)

    let value2 = -2
    let result2 = value2.clamped(to: -10...(-5))
    #expect(result2 == -5)

    let value3 = -7
    let result3 = value3.clamped(to: -10...(-5))
    #expect(result3 == -7)
  }

  @Test("Works with Character values")
  func worksWithCharacterValues() {
    let char1: Character = "a"
    let result1 = char1.clamped(to: "c"..."z")
    #expect(result1 == "c")

    let char2: Character = "z"
    let result2 = char2.clamped(to: "a"..."m")
    #expect(result2 == "m")

    let char3: Character = "g"
    let result3 = char3.clamped(to: "a"..."z")
    #expect(result3 == "g")
  }

  @Test("Works with String values")
  func worksWithStringValues() {
    let string1 = "apple"
    let result1 = string1.clamped(to: "banana"..."orange")
    #expect(result1 == "banana")

    let string2 = "zebra"
    let result2 = string2.clamped(to: "banana"..."orange")
    #expect(result2 == "orange")

    let string3 = "mango"
    let result3 = string3.clamped(to: "banana"..."orange")
    #expect(result3 == "mango")
  }
}
