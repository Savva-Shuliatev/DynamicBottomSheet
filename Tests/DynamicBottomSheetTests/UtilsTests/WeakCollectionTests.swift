//
//  WeakCollectionTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation
import Testing
@testable import DynamicBottomSheet

@Suite("WeakCollection Tests")
struct WeakCollectionTests {

  @Test("Insert single element")
  func testWeakCollectionInsertSingleElement() {
    var collection = WeakCollection<NSObject>()
    let object = NSObject()

    collection.insert(object)

    var count = 0
    collection.forEach { _ in count += 1 }
    #expect(count == 1)
    let isEmpty = collection.isEmpty()
    #expect(!isEmpty)
  }

  @Test("Insert duplicate element")
  func testWeakCollectionInsertDuplicateElement() {
    var collection = WeakCollection<NSObject>()
    let object = NSObject()

    collection.insert(object)
    collection.insert(object)

    var count = 0
    collection.forEach { _ in count += 1 }
    #expect(count == 1)
  }

  @Test("Insert multiple different elements")
  func testWeakCollectionInsertMultipleElements() {
    var collection = WeakCollection<NSObject>()
    let object1 = NSObject()
    let object2 = NSObject()
    let object3 = NSObject()

    collection.insert(object1)
    collection.insert(object2)
    collection.insert(object3)

    var count = 0
    collection.forEach { _ in count += 1 }
    #expect(count == 3)
  }

  @Test("Remove existing element")
  func testWeakCollectionRemoveExistingElement() {
    var collection = WeakCollection<NSObject>()
    let object1 = NSObject()
    let object2 = NSObject()

    collection.insert(object1)
    collection.insert(object2)
    collection.remove(object1)

    var count = 0
    var foundObject2 = false
    collection.forEach { obj in
      count += 1
      if obj === object2 {
        foundObject2 = true
      }
    }

    #expect(count == 1)
    #expect(foundObject2)
  }

  @Test("Remove non-existing element")
  func testWeakCollectionRemoveNonExistingElement() {
    var collection = WeakCollection<NSObject>()
    let object1 = NSObject()
    let object2 = NSObject()

    collection.insert(object1)
    collection.remove(object2)

    var count = 0
    collection.forEach { _ in count += 1 }
    #expect(count == 1)
  }

  @Test("Weak references are released")
  func testWeakCollectionWeakReferences() {
    var collection = WeakCollection<NSObject>()

    do {
      let object = NSObject()
      collection.insert(object)

      var count = 0
      collection.forEach { _ in count += 1 }
      #expect(count == 1)
    } // object goes out of scope and should be deallocated

    var countAfterDeallocation = 0
    collection.forEach { _ in countAfterDeallocation += 1 }
    #expect(countAfterDeallocation == 0)
    let isEmpty = collection.isEmpty()
    #expect(isEmpty)
  }

  @Test("isEmpty returns true for empty collection")
  func testWeakCollectionIsEmptyTrue() {
    var collection = WeakCollection<NSObject>()
    let isEmpty = collection.isEmpty()
    #expect(isEmpty)
  }

  @Test("isEmpty returns false for non-empty collection")
  func testWeakCollectionIsEmptyFalse() {
    var collection = WeakCollection<NSObject>()
    let object = NSObject()

    collection.insert(object)
    let isEmpty = collection.isEmpty()
    #expect(!isEmpty)
  }

  @Test("forEach with empty collection")
  func testWeakCollectionForEachEmpty() {
    let collection = WeakCollection<NSObject>()
    var count = 0

    collection.forEach { _ in count += 1 }
    #expect(count == 0)
  }

  @Test("forEach iterates over all elements")
  func testWeakCollectionForEachAllElements() {
    var collection = WeakCollection<NSObject>()
    let object1 = NSObject()
    let object2 = NSObject()
    let object3 = NSObject()

    collection.insert(object1)
    collection.insert(object2)
    collection.insert(object3)

    var visitedObjects: [NSObject] = []
    collection.forEach { obj in
      visitedObjects.append(obj)
    }

    #expect(visitedObjects.count == 3)
    #expect(visitedObjects.contains { $0 === object1 })
    #expect(visitedObjects.contains { $0 === object2 })
    #expect(visitedObjects.contains { $0 === object3 })
  }

  @Test("Multiple operations with deallocated objects")
  func testWeakCollectionMultipleOperationsWithDeallocatedObjects() {
    var collection = WeakCollection<NSObject>()
    let persistentObject = NSObject()

    collection.insert(persistentObject)

    do {
      let temporaryObject = NSObject()
      collection.insert(temporaryObject)

      var count = 0
      collection.forEach { _ in count += 1 }
      #expect(count == 2)
    }

    // After temporary object is deallocated
    var countAfter = 0
    collection.forEach { _ in countAfter += 1 }
    #expect(countAfter == 1)
    let isEmpty = collection.isEmpty()
    #expect(!isEmpty)
  }

  // MARK: - Weak<T> Tests

  @Test("Initialize with object")
  func testWeakInitializeWithObject() {
    let object = NSObject()
    let weak = Weak(object)

    #expect(weak.object === object)
  }

  @Test("Initialize with nil")
  func testWeakInitializeWithNil() {
    let weak = Weak<NSObject>(nil)

    #expect(weak.object == nil)
  }

  @Test("Equality with same object")
  func testWeakEqualityWithSameObject() {
    let object = NSObject()
    let weak1 = Weak(object)
    let weak2 = Weak(object)

    #expect(weak1 == weak2)
  }

  @Test("Equality with different objects")
  func testWeakEqualityWithDifferentObjects() {
    let object1 = NSObject()
    let object2 = NSObject()
    let weak1 = Weak(object1)
    let weak2 = Weak(object2)

    #expect(weak1 != weak2)
  }

  @Test("Equality with nil objects")
  func testWeakEqualityWithNilObjects() {
    let weak1 = Weak<NSObject>(nil)
    let weak2 = Weak<NSObject>(nil)

    #expect(weak1 == weak2)
  }

  @Test("Equality with one nil object")
  func testWeakEqualityWithOneNilObject() {
    let object = NSObject()
    let weak1 = Weak(object)
    let weak2 = Weak<NSObject>(nil)

    #expect(weak1 != weak2)
  }

  @Test("Object is deallocated")
  func testWeakObjectDeallocated() {
    var weak: Weak<NSObject>

    do {
      let object = NSObject()
      weak = Weak(object)
      #expect(weak.object != nil)
    }

    #expect(weak.object == nil)
  }

  @Test("Equality after deallocation")
  func testWeakEqualityAfterDeallocation() {
    var weak1: Weak<NSObject>
    var weak2: Weak<NSObject>

    do {
      let object1 = NSObject()
      let object2 = NSObject()
      weak1 = Weak(object1)
      weak2 = Weak(object2)
      #expect(weak1 != weak2)
    }

    // Both objects deallocated, both should be nil now
    #expect(weak1 == weak2)
  }

  // MARK: - Custom Test Class for Better Testing

  class TestObject {
    let identifier: String

    init(_ identifier: String) {
      self.identifier = identifier
    }
  }

  @Test("Custom class objects")
  func testWeakCollectionWithCustomClass() {
    var collection = WeakCollection<TestObject>()
    let object1 = TestObject("1")
    let object2 = TestObject("2")

    collection.insert(object1)
    collection.insert(object2)

    var identifiers: [String] = []
    collection.forEach { obj in
      identifiers.append(obj.identifier)
    }

    #expect(identifiers.count == 2)
    #expect(identifiers.contains("1"))
    #expect(identifiers.contains("2"))
  }

  @Test("Type safety")
  func testWeakCollectionTypeSafety() {
    var stringCollection = WeakCollection<NSString>()
    var numberCollection = WeakCollection<NSNumber>()

    let string = NSString(string: "test")
    let number = NSNumber(value: 42)

    stringCollection.insert(string)
    numberCollection.insert(number)

    var stringCount = 0
    var numberCount = 0

    stringCollection.forEach { _ in stringCount += 1 }
    numberCollection.forEach { _ in numberCount += 1 }

    #expect(stringCount == 1)
    #expect(numberCount == 1)
  }
}
