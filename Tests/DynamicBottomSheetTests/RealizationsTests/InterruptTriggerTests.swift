//
//  InterruptTriggerTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import DynamicBottomSheet

struct InterruptTriggerTests {

  @Test("Empty trigger has zero raw value")
  func testEmptyTrigger() {
    #expect(DynamicBottomSheet.InterruptTrigger.empty.rawValue == 0)
    #expect(DynamicBottomSheet.InterruptTrigger.empty.isEmpty)
  }

  @Test("All trigger contains all individual triggers")
  func testAllTrigger() {
    let all = DynamicBottomSheet.InterruptTrigger.all
    #expect(all.contains(.panGesture))
    #expect(all.contains(.scrollDragging))
    #expect(all.contains(.program))
  }

  @Test("Combining triggers works correctly")
  func testCombiningTriggers() {
    let combined: DynamicBottomSheet.InterruptTrigger = [.panGesture, .program]
    #expect(combined.contains(.panGesture))
    #expect(combined.contains(.program))
    #expect(!combined.contains(.scrollDragging))
  }

  @Test("Trigger intersection works correctly")
  func testTriggerIntersection() {
    let trigger1: DynamicBottomSheet.InterruptTrigger = [.panGesture, .program]
    let trigger2: DynamicBottomSheet.InterruptTrigger = [.panGesture, .scrollDragging]

    let intersection = trigger1.intersection(trigger2)
    #expect(intersection == .panGesture)
  }

  @Test("Trigger union works correctly")
  func testTriggerUnion() {
    let trigger1: DynamicBottomSheet.InterruptTrigger = [.panGesture]
    let trigger2: DynamicBottomSheet.InterruptTrigger = [.scrollDragging]

    let union = trigger1.union(trigger2)
    #expect(union.contains(.panGesture))
    #expect(union.contains(.scrollDragging))
    #expect(!union.contains(.program))
  }

  @Test("Trigger subtraction works correctly")
  func testTriggerSubtraction() {
    let allTriggers = DynamicBottomSheet.InterruptTrigger.all
    let result = allTriggers.subtracting(.panGesture)

    #expect(!result.contains(.panGesture))
    #expect(result.contains(.scrollDragging))
    #expect(result.contains(.program))
  }

  @Test("Trigger equality works correctly")
  func testTriggerEquality() {
    let trigger1: DynamicBottomSheet.InterruptTrigger = [.panGesture, .program]
    let trigger2: DynamicBottomSheet.InterruptTrigger = [.program, .panGesture]

    #expect(trigger1 == trigger2)
    #expect(trigger1 != .all)
  }

  @Test("Custom initializer works correctly")
  func testCustomInitializer() {
    let customTrigger = DynamicBottomSheet.InterruptTrigger(rawValue: 5) // 1 + 4 = panGesture + program
    #expect(customTrigger.contains(.panGesture))
    #expect(customTrigger.contains(.program))
    #expect(!customTrigger.contains(.scrollDragging))
  }
}
