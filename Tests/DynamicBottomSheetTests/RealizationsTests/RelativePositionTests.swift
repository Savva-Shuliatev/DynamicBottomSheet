//
//  RelativePositionTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation
import Testing
@testable import DynamicBottomSheet

@Suite("RelativePosition Tests")
struct RelativePositionTests {

  @Suite("Edge Cases")
  struct EdgeTests {

    @Test("Edge equality")
    func edgeEquality() {
      #expect(RelativePosition.Edge.top == RelativePosition.Edge.top)
      #expect(RelativePosition.Edge.middle == RelativePosition.Edge.middle)
      #expect(RelativePosition.Edge.bottom == RelativePosition.Edge.bottom)
      #expect(RelativePosition.Edge.proportion(0.5) == RelativePosition.Edge.proportion(0.5))

      #expect(RelativePosition.Edge.top != RelativePosition.Edge.bottom)
      #expect(RelativePosition.Edge.proportion(0.3) != RelativePosition.Edge.proportion(0.7))
    }

    @Test("Edge proportion values")
    func edgeProportionValues() {
      let edge1 = RelativePosition.Edge.proportion(0.0)
      let edge2 = RelativePosition.Edge.proportion(1.0)
      let edge3 = RelativePosition.Edge.proportion(0.5)

      #expect(edge1 == RelativePosition.Edge.proportion(0.0))
      #expect(edge2 == RelativePosition.Edge.proportion(1.0))
      #expect(edge3 == RelativePosition.Edge.proportion(0.5))
    }
  }

  @Suite("Initialization")
  struct InitializationTests {

    @Test("Internal initializer")
    func internalInitializer() {
      let position = RelativePosition(
        offset: 100,
        edge: .top,
        ignoresSafeArea: true
      )

      #expect(position.offset == 100)
      #expect(position.edge == .top)
      #expect(position.ignoresSafeArea == true)
    }

    @Test("Internal initializer with defaults")
    func internalInitializerWithDefaults() {
      let position = RelativePosition(
        offset: 50,
        edge: .middle
      )

      #expect(position.offset == 50)
      #expect(position.edge == .middle)
      #expect(position.ignoresSafeArea == false)
    }
  }

  @Suite("Static Factory Methods")
  struct StaticFactoryMethodsTests {

    @Test("fromTop with offset")
    func fromTopWithOffset() {
      let position = RelativePosition.fromTop(100)

      #expect(position.offset == 100)
      #expect(position.edge == .top)
      #expect(position.ignoresSafeArea == false)
    }

    @Test("fromTop with offset and ignoresSafeArea")
    func fromTopWithOffsetAndIgnoresSafeArea() {
      let position = RelativePosition.fromTop(50, ignoresSafeArea: true)

      #expect(position.offset == 50)
      #expect(position.edge == .top)
      #expect(position.ignoresSafeArea == true)
    }

    @Test("top with default parameters")
    func topWithDefaultParameters() {
      let position = RelativePosition.top()

      #expect(position.offset == 0)
      #expect(position.edge == .top)
      #expect(position.ignoresSafeArea == false)
    }

    @Test("top with ignoresSafeArea")
    func topWithIgnoresSafeArea() {
      let position = RelativePosition.top(ignoresSafeArea: true)

      #expect(position.offset == 0)
      #expect(position.edge == .top)
      #expect(position.ignoresSafeArea == true)
    }

    @Test("middle with default parameters")
    func middleWithDefaultParameters() {
      let position = RelativePosition.middle()

      #expect(position.offset == 0)
      #expect(position.edge == .middle)
      #expect(position.ignoresSafeArea == false)
    }

    @Test("middle with offset")
    func middleWithOffset() {
      let position = RelativePosition.middle(offset: 25)

      #expect(position.offset == 25)
      #expect(position.edge == .middle)
      #expect(position.ignoresSafeArea == false)
    }

    @Test("middle with offset and withSafeArea false")
    func middleWithOffsetAndWithSafeAreaFalse() {
      let position = RelativePosition.middle(offset: -10, withSafeArea: false)

      #expect(position.offset == -10)
      #expect(position.edge == .middle)
      #expect(position.ignoresSafeArea == true)
    }

    @Test("fromBottom with offset")
    func fromBottomWithOffset() {
      let position = RelativePosition.fromBottom(200)

      #expect(position.offset == 200)
      #expect(position.edge == .bottom)
      #expect(position.ignoresSafeArea == false)
    }

    @Test("fromBottom with offset and ignoresSafeArea")
    func fromBottomWithOffsetAndIgnoresSafeArea() {
      let position = RelativePosition.fromBottom(150, ignoresSafeArea: true)

      #expect(position.offset == 150)
      #expect(position.edge == .bottom)
      #expect(position.ignoresSafeArea == true)
    }

    @Test("bottom with default parameters")
    func bottomWithDefaultParameters() {
      let position = RelativePosition.bottom()

      #expect(position.offset == 0)
      #expect(position.edge == .bottom)
      #expect(position.ignoresSafeArea == false)
    }

    @Test("bottom with ignoresSafeArea")
    func bottomWithIgnoresSafeArea() {
      let position = RelativePosition.bottom(ignoresSafeArea: true)

      #expect(position.offset == 0)
      #expect(position.edge == .bottom)
      #expect(position.ignoresSafeArea == true)
    }

    @Test("proportion with default parameters")
    func proportionWithDefaultParameters() {
      let position = RelativePosition.proportion(0.7)

      #expect(position.offset == 0)
      #expect(position.edge == .proportion(0.7))
      #expect(position.ignoresSafeArea == false)
    }

    @Test("proportion with offset")
    func proportionWithOffset() {
      let position = RelativePosition.proportion(0.3, offset: 30)

      #expect(position.offset == 30)
      #expect(position.edge == .proportion(0.3))
      #expect(position.ignoresSafeArea == false)
    }

    @Test("proportion with offset and withSafeArea false")
    func proportionWithOffsetAndWithSafeAreaFalse() {
      let position = RelativePosition.proportion(0.9, offset: -20, withSafeArea: false)

      #expect(position.offset == -20)
      #expect(position.edge == .proportion(0.9))
      #expect(position.ignoresSafeArea == true)
    }
  }

  @Suite("Predefined Constants")
  struct PredefinedConstantsTests {

    @Test("hidden constant")
    func hiddenConstant() {
      let hiddenPosition = RelativePosition.hidden

      #expect(hiddenPosition.offset == 0)
      #expect(hiddenPosition.edge == .bottom)
      #expect(hiddenPosition.ignoresSafeArea == true)
    }
  }

  @Suite("Equatable Conformance")
  struct EquatableConformanceTests {

    @Test("Equal positions")
    func equalPositions() {
      let position1 = RelativePosition.fromTop(100, ignoresSafeArea: true)
      let position2 = RelativePosition.fromTop(100, ignoresSafeArea: true)

      #expect(position1 == position2)
    }

    @Test("Different offsets")
    func differentOffsets() {
      let position1 = RelativePosition.fromTop(100)
      let position2 = RelativePosition.fromTop(200)

      #expect(position1 != position2)
    }

    @Test("Different edges")
    func differentEdges() {
      let position1 = RelativePosition.fromTop(100)
      let position2 = RelativePosition.fromBottom(100)

      #expect(position1 != position2)
    }

    @Test("Different ignoresSafeArea")
    func differentIgnoresSafeArea() {
      let position1 = RelativePosition.fromTop(100, ignoresSafeArea: true)
      let position2 = RelativePosition.fromTop(100, ignoresSafeArea: false)

      #expect(position1 != position2)
    }

    @Test("Equal proportion positions")
    func equalProportionPositions() {
      let position1 = RelativePosition.proportion(0.5, offset: 25, withSafeArea: false)
      let position2 = RelativePosition.proportion(0.5, offset: 25, withSafeArea: false)

      #expect(position1 == position2)
    }

    @Test("Different proportion values")
    func differentProportionValues() {
      let position1 = RelativePosition.proportion(0.3)
      let position2 = RelativePosition.proportion(0.7)

      #expect(position1 != position2)
    }
  }

  @Suite("Edge Cases and Boundary Values")
  struct EdgeCasesAndBoundaryValuesTests {

    @Test("Zero offset")
    func zeroOffset() {
      let position = RelativePosition.fromTop(0)

      #expect(position.offset == 0)
      #expect(position.edge == .top)
    }

    @Test("Negative offset")
    func negativeOffset() {
      let position = RelativePosition.middle(offset: -50)

      #expect(position.offset == -50)
      #expect(position.edge == .middle)
    }

    @Test("Large positive offset")
    func largePositiveOffset() {
      let position = RelativePosition.fromBottom(1000)

      #expect(position.offset == 1000)
      #expect(position.edge == .bottom)
    }

    @Test("Proportion boundary values")
    func proportionBoundaryValues() {
      let position1 = RelativePosition.proportion(0.0)
      let position2 = RelativePosition.proportion(1.0)

      #expect(position1.edge == .proportion(0.0))
      #expect(position2.edge == .proportion(1.0))
    }

    @Test("Proportion extreme values")
    func proportionExtremeValues() {
      let position1 = RelativePosition.proportion(-0.5)
      let position2 = RelativePosition.proportion(1.5)

      #expect(position1.edge == .proportion(-0.5))
      #expect(position2.edge == .proportion(1.5))
    }
  }

  @Suite("Sendable Conformance")
  struct SendableConformanceTests {

    @Test("Sendable usage across concurrency boundaries")
    func sendableUsage() async {
      let position = RelativePosition.fromTop(100)

      await withTaskGroup(of: Void.self) { group in
        group.addTask {
          let localPosition = position
          #expect(localPosition.offset == 100)
        }
      }
    }
  }
}
