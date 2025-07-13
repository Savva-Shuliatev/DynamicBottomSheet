//
//  CollectionNearestElementTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet

@Suite("Collection nearestElement Tests")
struct CollectionNearestElementTests {

  // MARK: - Basic Functionality Tests

  @Test("Find nearest element in integer array")
  func testNearestElementWithIntegers() {
    let numbers = [1, 5, 3, 9, 7]

    #expect(numbers.nearestElement(to: 6) == 5)
    #expect(numbers.nearestElement(to: 2) == 1)
    #expect(numbers.nearestElement(to: 8) == 9)
    #expect(numbers.nearestElement(to: 10) == 9)
  }

  @Test("Find nearest element in double array")
  func testNearestElementWithDoubles() {
    let doubles = [1.2, 3.8, 2.1, 5.5]

    #expect(doubles.nearestElement(to: 2.0) == 2.1)
    #expect(doubles.nearestElement(to: 4.0) == 3.8)
    #expect(doubles.nearestElement(to: 0.5) == 1.2)
  }

  @Test("Find nearest element with exact match")
  func testExactMatch() {
    let numbers = [10, 20, 30, 40]

    #expect(numbers.nearestElement(to: 20) == 20)
    #expect(numbers.nearestElement(to: 40) == 40)
  }

  // MARK: - Edge Cases

  @Test("Empty collection returns nil")
  func testEmptyCollection() {
    let emptyInts: [Int] = []
    let emptyDoubles: [Double] = []

    #expect(emptyInts.nearestElement(to: 5) == nil)
    #expect(emptyDoubles.nearestElement(to: 3.14) == nil)
  }

  @Test("Single element collection")
  func testSingleElement() {
    let singleInt = [42]
    let singleDouble = [3.14]

    #expect(singleInt.nearestElement(to: 100) == 42)
    #expect(singleInt.nearestElement(to: 0) == 42)
    #expect(singleDouble.nearestElement(to: 10.0) == 3.14)
  }

  @Test("All elements equidistant - returns first occurrence")
  func testEquidistantElements() {
    let numbers = [2, 6] // Both are distance 2 from 4

    #expect(numbers.nearestElement(to: 4) == 2) // Should return first element
  }

  @Test("Negative numbers")
  func testNegativeNumbers() {
    let numbers = [-5, -2, 1, 4]

    #expect(numbers.nearestElement(to: -3) == -2)
    #expect(numbers.nearestElement(to: 0) == 1)
    #expect(numbers.nearestElement(to: -10) == -5)
  }

  @Test("Mixed positive and negative numbers")
  func testMixedNumbers() {
    let numbers = [-10, -5, 0, 5, 10]

    #expect(numbers.nearestElement(to: 3) == 5)
    #expect(numbers.nearestElement(to: -3) == -5)
    #expect(numbers.nearestElement(to: 0) == 0)
  }

  // MARK: - Duplicate Values

  @Test("Array with duplicates")
  func testDuplicateValues() {
    let numbers = [1, 3, 3, 5, 5, 7]

    #expect(numbers.nearestElement(to: 4) == 3) // Should return first occurrence of 3
    #expect(numbers.nearestElement(to: 6) == 5) // Should return first occurrence of 5
  }

  @Test("All same values")
  func testAllSameValues() {
    let numbers = [5, 5, 5, 5]

    #expect(numbers.nearestElement(to: 3) == 5)
    #expect(numbers.nearestElement(to: 8) == 5)
    #expect(numbers.nearestElement(to: 5) == 5)
  }

  // MARK: - Different Collection Types

  @Test("Set collection")
  func testSetCollection() {
    let numberSet: Set<Int> = [1, 3, 5, 7, 9]

    let result = numberSet.nearestElement(to: 4)
    #expect(result == 3 || result == 5) // Could be either due to Set ordering
  }

  @Test("Array slice")
  func testArraySlice() {
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    let slice = numbers[3..<7] // [4, 5, 6, 7]

    #expect(slice.nearestElement(to: 5) == 5)
    #expect(slice.nearestElement(to: 3) == 4)
    #expect(slice.nearestElement(to: 8) == 7)
  }

  // MARK: - Performance Edge Cases

  @Test("Large array performance")
  func testLargeArray() {
    let largeArray = Array(1...10000)

    #expect(largeArray.nearestElement(to: 5000) == 5000)
    #expect(largeArray.nearestElement(to: 5001) == 5001)
    #expect(largeArray.nearestElement(to: 0) == 1)
    #expect(largeArray.nearestElement(to: 15000) == 10000)
  }

  // MARK: - Floating Point Precision

  @Test("Floating point precision")
  func testFloatingPointPrecision() {
    let doubles = [0.1, 0.2, 0.3]

    // Test with potential floating point precision issues
    #expect(doubles.nearestElement(to: 0.15) == 0.1)
    #expect(doubles.nearestElement(to: 0.25) == 0.2)
  }

}
