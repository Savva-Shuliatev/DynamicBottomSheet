//
//  MainActorSyncSafeTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation
import Testing
@testable import DynamicBottomSheet

struct MainActorSyncSafeTests {

  @Test("syncSafe executes action on main thread when called from main thread")
  @MainActor
  func testSyncSafeOnMainThread() async {
    var executed = false
    let expectedValue = 42

    let result = MainActor.syncSafe {
      executed = true
      return expectedValue
    }

    #expect(executed == true)
    #expect(result == expectedValue)
    #expect(Thread.isMain == true)
  }

  @Test("syncSafe executes action on main thread when called from background thread")
  func testSyncSafeOnBackgroundThread() async {
    var executed = false
    var wasMainThread = false
    let expectedValue = "test"

    await withCheckedContinuation { continuation in
      DispatchQueue.global().async {
        let result = MainActor.syncSafe {
          executed = true
          wasMainThread = Thread.isMainThread
          return expectedValue
        }

        #expect(executed == true)
        #expect(result == expectedValue)
        #expect(wasMainThread == true)
        continuation.resume()
      }
    }
  }

  @Test("syncSafe returns correct value type")
  @MainActor
  func testSyncSafeReturnValue() async {
    let stringResult = MainActor.syncSafe {
      return "Hello, World!"
    }
    #expect(stringResult == "Hello, World!")

    let intResult = MainActor.syncSafe {
      return 100
    }
    #expect(intResult == 100)

    let boolResult = MainActor.syncSafe {
      return true
    }
    #expect(boolResult == true)
  }

  @Test("syncSafe handles void return type")
  @MainActor
  func testSyncSafeVoidReturn() async {
    var sideEffect = false

    MainActor.syncSafe {
      sideEffect = true
    }

    #expect(sideEffect == true)
  }

  @Test("syncSafe with complex sendable types")
  @MainActor
  func testSyncSafeWithComplexTypes() async {
    struct TestStruct: Sendable {
      let id: Int
      let name: String
    }

    let expectedStruct = TestStruct(id: 1, name: "Test")

    let result = MainActor.syncSafe {
      return expectedStruct
    }

    #expect(result.id == expectedStruct.id)
    #expect(result.name == expectedStruct.name)
  }

  @Test("syncSafe executes synchronously from background thread")
  func testSyncSafeSynchronousExecution() async {
    var executionOrder: [Int] = []

    await withCheckedContinuation { continuation in
      DispatchQueue.global().async {
        executionOrder.append(1)

        MainActor.syncSafe {
          executionOrder.append(2)
        }

        executionOrder.append(3)

        #expect(executionOrder == [1, 2, 3])
        continuation.resume()
      }
    }
  }

  @Test("syncSafe maintains thread safety")
  func testSyncSafeThreadSafety() async {
    let iterations = 10
    var sharedCounter = 0

    await withTaskGroup(of: Void.self) { group in
      for _ in 0..<iterations {
        group.addTask {
          await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
              MainActor.syncSafe {
                sharedCounter += 1
              }
              continuation.resume()
            }
          }
        }
      }
    }

    await MainActor.run {
      #expect(sharedCounter == iterations)
    }
  }

  @Test("syncSafe with optional return type")
  @MainActor
  func testSyncSafeWithOptional() async {
    let nilResult: String? = MainActor.syncSafe {
      return nil
    }
    #expect(nilResult == nil)

    let valueResult: String? = MainActor.syncSafe {
      return "Not nil"
    }
    #expect(valueResult == "Not nil")
  }

  @Test("syncSafe performance baseline")
  @MainActor
  func testSyncSafePerformance() async {
    let iterations = 1000
    let startTime = CFAbsoluteTimeGetCurrent()

    for _ in 0..<iterations {
      MainActor.syncSafe {
        return 42
      }
    }

    let endTime = CFAbsoluteTimeGetCurrent()
    let executionTime = endTime - startTime

    // Performance should be reasonable (adjust threshold as needed)
    #expect(executionTime < 1.0)
  }

  @Test("syncSafe with multiple background threads")
  func testSyncSafeMultipleBackgroundThreads() async {
    let threadCount = 5
    var results: [String] = []

    await withTaskGroup(of: String.self) { group in
      for i in 0..<threadCount {
        group.addTask {
          await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
              let result = MainActor.syncSafe {
                return "Thread \(i)"
              }
              continuation.resume(returning: result)
            }
          }
        }
      }

      for await result in group {
        results.append(result)
      }
    }

    #expect(results.count == threadCount)
    #expect(results.allSatisfy { $0.hasPrefix("Thread") })
  }

  @Test("syncSafe with throwing function")
  @MainActor
  func testSyncSafeWithThrowingFunction() async {
    enum TestError: Error {
      case testFailure
    }

    // Test successful case
    let successResult = MainActor.syncSafe {
      return "Success"
    }
    #expect(successResult == "Success")

    // Note: syncSafe doesn't handle throwing functions directly
    // This is by design as it returns T, not throws T
  }

  @Test("syncSafe with actor isolated state")
  @MainActor
  func testSyncSafeWithActorIsolatedState() async {
    @MainActor
    class TestClass {
      var value: Int = 0

      func increment() {
        value += 1
      }
    }

    let testObject = TestClass()

    MainActor.syncSafe {
      testObject.increment()
      testObject.increment()
    }

    #expect(testObject.value == 2)
  }
}

fileprivate extension Thread {
  static var isMain: Bool { isMainThread }
}
