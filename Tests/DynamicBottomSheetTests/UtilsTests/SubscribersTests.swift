//
//  SubscribersTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
import Foundation
@testable import DynamicBottomSheet

@Suite("Subscribers Tests")
struct SubscribersTests {

  // MARK: - Test Helper Classes

  final class TestSubscriber {
    let id: String

    init(id: String) {
      self.id = id
    }
  }

  final class AnotherTestSubscriber {
    let name: String

    init(name: String) {
      self.name = name
    }
  }

  // MARK: - Initialization Tests

  @Test("Subscribers initializes with empty collection")
  func testInitialization() {
    let subscribers = Subscribers<TestSubscriber>()

    #expect(subscribers.isEmpty)
  }

  // MARK: - Subscribe Tests

  @Test("Subscribe adds subscriber to collection")
  func testSubscribe() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber = TestSubscriber(id: "test1")

    subscribers.subscribe(subscriber)

    #expect(!subscribers.isEmpty)
  }

  @Test("Subscribe multiple subscribers")
  func testSubscribeMultiple() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber1 = TestSubscriber(id: "test1")
    let subscriber2 = TestSubscriber(id: "test2")

    subscribers.subscribe(subscriber1)
    subscribers.subscribe(subscriber2)

    #expect(!subscribers.isEmpty)

    var calledSubscribers: [String] = []
    subscribers.forEach { subscriber in
      calledSubscribers.append(subscriber.id)
    }

    #expect(calledSubscribers.count == 2)
    #expect(calledSubscribers.contains("test1"))
    #expect(calledSubscribers.contains("test2"))
  }

  @Test("Subscribe same subscriber multiple times")
  func testSubscribeSameSubscriberMultipleTimes() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber = TestSubscriber(id: "test1")

    subscribers.subscribe(subscriber)
    subscribers.subscribe(subscriber)

    var callCount = 0
    subscribers.forEach { _ in
      callCount += 1
    }

    // Should handle duplicates appropriately based on WeakCollection implementation
    #expect(callCount >= 1)
  }

  // MARK: - Unsubscribe Tests

  @Test("Unsubscribe removes subscriber from collection")
  func testUnsubscribe() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber = TestSubscriber(id: "test1")

    subscribers.subscribe(subscriber)
    #expect(!subscribers.isEmpty)

    subscribers.unsubscribe(subscriber)

    var callCount = 0
    subscribers.forEach { _ in
      callCount += 1
    }

    #expect(callCount == 0)
  }

  @Test("Unsubscribe specific subscriber from multiple")
  func testUnsubscribeSpecificSubscriber() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber1 = TestSubscriber(id: "test1")
    let subscriber2 = TestSubscriber(id: "test2")

    subscribers.subscribe(subscriber1)
    subscribers.subscribe(subscriber2)

    subscribers.unsubscribe(subscriber1)

    var remainingSubscribers: [String] = []
    subscribers.forEach { subscriber in
      remainingSubscribers.append(subscriber.id)
    }

    #expect(remainingSubscribers.count == 1)
    #expect(remainingSubscribers.contains("test2"))
    #expect(!remainingSubscribers.contains("test1"))
  }

  @Test("Unsubscribe non-existent subscriber")
  func testUnsubscribeNonExistentSubscriber() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber1 = TestSubscriber(id: "test1")
    let subscriber2 = TestSubscriber(id: "test2")

    subscribers.subscribe(subscriber1)
    subscribers.unsubscribe(subscriber2) // This subscriber was never added

    #expect(!subscribers.isEmpty)

    var callCount = 0
    subscribers.forEach { _ in
      callCount += 1
    }

    #expect(callCount == 1)
  }

  // MARK: - forEach Tests

  @Test("forEach executes block for each subscriber")
  func testForEach() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber1 = TestSubscriber(id: "test1")
    let subscriber2 = TestSubscriber(id: "test2")

    subscribers.subscribe(subscriber1)
    subscribers.subscribe(subscriber2)

    var executedIds: [String] = []
    subscribers.forEach { subscriber in
      executedIds.append(subscriber.id)
    }

    #expect(executedIds.count == 2)
    #expect(executedIds.contains("test1"))
    #expect(executedIds.contains("test2"))
  }

  @Test("forEach on empty collection")
  func testForEachEmpty() {
    let subscribers = Subscribers<TestSubscriber>()

    var callCount = 0
    subscribers.forEach { _ in
      callCount += 1
    }

    #expect(callCount == 0)
  }

  @Test("forEach with side effects")
  func testForEachWithSideEffects() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber1 = TestSubscriber(id: "test1")
    let subscriber2 = TestSubscriber(id: "test2")

    subscribers.subscribe(subscriber1)
    subscribers.subscribe(subscriber2)

    var modifiedIds: [String] = []
    subscribers.forEach { subscriber in
      modifiedIds.append(subscriber.id.uppercased())
    }

    #expect(modifiedIds.count == 2)
    #expect(modifiedIds.contains("TEST1"))
    #expect(modifiedIds.contains("TEST2"))
  }

  // MARK: - isEmpty Tests

  @Test("isEmpty returns true for empty collection")
  func testIsEmptyTrue() {
    let subscribers = Subscribers<TestSubscriber>()

    #expect(subscribers.isEmpty)
  }

  @Test("isEmpty returns false for non-empty collection")
  func testIsEmptyFalse() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber = TestSubscriber(id: "test1")

    subscribers.subscribe(subscriber)

    #expect(!subscribers.isEmpty)
  }

  @Test("isEmpty after subscribe and unsubscribe")
  func testIsEmptyAfterSubscribeAndUnsubscribe() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber = TestSubscriber(id: "test1")

    subscribers.subscribe(subscriber)
    #expect(!subscribers.isEmpty)

    subscribers.unsubscribe(subscriber)
    #expect(subscribers.isEmpty)
  }

  // MARK: - Weak Reference Tests

  @Test("Weak references are cleaned up automatically")
  func testWeakReferenceCleanup() {
    let subscribers = Subscribers<TestSubscriber>()

    do {
      let subscriber = TestSubscriber(id: "test1")
      subscribers.subscribe(subscriber)
      #expect(!subscribers.isEmpty)
    } // subscriber goes out of scope and should be deallocated

    // Force garbage collection by creating some objects
    for i in 0..<100 {
      _ = TestSubscriber(id: "temp\(i)")
    }

    var callCount = 0
    subscribers.forEach { _ in
      callCount += 1
    }

    // The weak reference should have been cleaned up
    #expect(callCount == 0)
  }

  // MARK: - Type Safety Tests

  @Test("Different subscriber types are handled separately")
  func testDifferentSubscriberTypes() {
    let stringSubscribers = Subscribers<TestSubscriber>()
    let intSubscribers = Subscribers<AnotherTestSubscriber>()

    let testSubscriber = TestSubscriber(id: "test")
    let anotherSubscriber = AnotherTestSubscriber(name: "another")

    stringSubscribers.subscribe(testSubscriber)
    intSubscribers.subscribe(anotherSubscriber)

    #expect(!stringSubscribers.isEmpty)
    #expect(!intSubscribers.isEmpty)

    var testCallCount = 0
    var anotherCallCount = 0

    stringSubscribers.forEach { _ in
      testCallCount += 1
    }

    intSubscribers.forEach { _ in
      anotherCallCount += 1
    }

    #expect(testCallCount == 1)
    #expect(anotherCallCount == 1)
  }

  // MARK: - Edge Cases

  @Test("Multiple subscribe and unsubscribe operations")
  func testMultipleOperations() {
    let subscribers = Subscribers<TestSubscriber>()
    let subscriber1 = TestSubscriber(id: "test1")
    let subscriber2 = TestSubscriber(id: "test2")
    let subscriber3 = TestSubscriber(id: "test3")

    subscribers.subscribe(subscriber1)
    subscribers.subscribe(subscriber2)
    subscribers.subscribe(subscriber3)

    subscribers.unsubscribe(subscriber2)

    subscribers.subscribe(subscriber2) // Re-subscribe

    var activeSubscribers: [String] = []
    subscribers.forEach { subscriber in
      activeSubscribers.append(subscriber.id)
    }

    #expect(activeSubscribers.count == 3)
    #expect(activeSubscribers.contains("test1"))
    #expect(activeSubscribers.contains("test2"))
    #expect(activeSubscribers.contains("test3"))
  }
}
