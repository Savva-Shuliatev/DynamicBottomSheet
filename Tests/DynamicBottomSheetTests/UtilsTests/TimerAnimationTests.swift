//
//  TimerAnimationTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation
import QuartzCore
import Testing
@testable import DynamicBottomSheet

@Suite("TimerAnimation Tests")
struct TimerAnimationTests {

  @Test("Initialization creates running timer")
  func testInitialization() {
    let animation = TimerAnimation(animations: { _ in .continue })
    #expect(animation.running == true)
  }

  @Test("Animation block is called with elapsed time")
  func testAnimationBlockCalled() async {
    var receivedTime: TimeInterval?
    let expectation = Expectation()

    let animation = TimerAnimation(animations: { time in
      receivedTime = time
      expectation.fulfill()
      return .finish
    })

    await expectation.fulfillment(timeout: 1.0)

    #expect(receivedTime != nil)
    #expect(receivedTime! >= 0)
    animation.invalidate(withCompletion: false)
  }

  @Test("Animation continues when returning .continue")
  func testAnimationContinues() async {
    var callCount = 0
    let expectation = Expectation()

    let animation = TimerAnimation(animations: { _ in
      callCount += 1
      if callCount >= 3 {
        expectation.fulfill()
        return .finish
      }
      return .continue
    })

    await expectation.fulfillment(timeout: 1.0)

    #expect(callCount >= 3)
    animation.invalidate(withCompletion: false)
  }

  @Test("Animation finishes when returning .finish")
  func testAnimationFinishes() async {
    var completionCalled = false
    var completionFinished: Bool?
    let expectation = Expectation()

    let animation = TimerAnimation(
      animations: { _ in .finish },
      completion: { finished in
        completionCalled = true
        completionFinished = finished
        expectation.fulfill()
      }
    )

    await expectation.fulfillment(timeout: 1.0)

    #expect(completionCalled == true)
    #expect(completionFinished == true)
    #expect(animation.running == false)
  }

  @Test("Invalidate stops animation and calls completion with false")
  func testInvalidateWithCompletion() async {
    var completionCalled = false
    var completionFinished: Bool?
    let expectation = Expectation()

    let animation = TimerAnimation(
      animations: { _ in .continue },
      completion: { finished in
        completionCalled = true
        completionFinished = finished
        expectation.fulfill()
      }
    )

    try? await Task.sleep(nanoseconds: 10_000_000) // 10ms

    animation.invalidate(withCompletion: true)

    await expectation.fulfillment(timeout: 1.0)

    #expect(completionCalled == true)
    #expect(completionFinished == false)
    #expect(animation.running == false)
  }

  @Test("Invalidate without completion doesn't call completion")
  func testInvalidateWithoutCompletion() async {
    var completionCalled = false

    let animation = TimerAnimation(
      animations: { _ in .continue },
      completion: { _ in
        completionCalled = true
      }
    )

    try? await Task.sleep(nanoseconds: 10_000_000) // 10ms

    animation.invalidate(withCompletion: false)

    try? await Task.sleep(nanoseconds: 100_000_000) // 100ms

    #expect(completionCalled == false)
    #expect(animation.running == false)
  }

  @Test("Multiple invalidate calls are safe")
  func testMultipleInvalidateCalls() async {
    var completionCallCount = 0
    let expectation = Expectation()

    let animation = TimerAnimation(
      animations: { _ in .continue },
      completion: { _ in
        completionCallCount += 1
        expectation.fulfill()
      }
    )

    try? await Task.sleep(nanoseconds: 10_000_000) // 10ms

    animation.invalidate(withCompletion: true)
    animation.invalidate(withCompletion: true)
    animation.invalidate(withCompletion: true)

    await expectation.fulfillment(timeout: 1.0)

    #expect(completionCallCount == 1)
    #expect(animation.running == false)
  }

  @Test("Timer without completion handler works correctly")
  func testTimerWithoutCompletionHandler() async {
    var animationCalled = false
    let expectation = Expectation()

    let animation = TimerAnimation(animations: { _ in
      animationCalled = true
      expectation.fulfill()
      return .finish
    })

    await expectation.fulfillment(timeout: 1.0)

    #expect(animationCalled == true)
    #expect(animation.running == false)
  }

  @Test("Elapsed time increases between frames")
  func testElapsedTimeIncreases() async {
    var previousTime: TimeInterval = -1
    var timeIncreased = false
    var callCount = 0
    let expectation = Expectation()

    let animation = TimerAnimation(animations: { time in
      callCount += 1

      if previousTime >= 0 && time > previousTime {
        timeIncreased = true
      }
      previousTime = time

      if callCount >= 3 {
        expectation.fulfill()
        return .finish
      }
      return .continue
    })

    await expectation.fulfillment(timeout: 1.0)

    #expect(timeIncreased == true)
    animation.invalidate(withCompletion: false)
  }

  @Test("Deinit invalidates timer")
  func testDeinitInvalidatesTimer() async {
    var completionCalled = false
    let expectation = Expectation()

    do {
      let animation: TimerAnimation? = TimerAnimation(
        animations: { _ in .continue },
        completion: { finished in
          completionCalled = true
          expectation.fulfill()
        }
      )

      try? await Task.sleep(nanoseconds: 10_000_000) // 10ms
    }

    await expectation.fulfillment(timeout: 1.0)

    #expect(completionCalled == true)
  }
}

// MARK: Helper

final private class Expectation {
  private var isFulfilled = false
  private let lock = NSLock()

  func fulfill() {
    lock.lock()
    isFulfilled = true
    lock.unlock()
  }

  func fulfillment(timeout: TimeInterval) async {
    let startTime = CACurrentMediaTime()

    while !isFulfilled {
      if CACurrentMediaTime() - startTime > timeout {
        break
      }
      try? await Task.sleep(nanoseconds: 1_000_000) // 1ms
    }
  }
}
