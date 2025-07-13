//
//  UIViewConstraintExtensionTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import Testing
@testable import DynamicBottomSheet

@Suite("UIView Constraint Extension Tests")
@MainActor
struct UIViewConstraintExtensionTests {

  @Test("constraint with same attribute creates proper constraint")
  func testConstraintWithSameAttribute() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    let constraint = childView.constraint(.top, equalTo: parentView)

    #expect(constraint.firstItem === childView)
    #expect(constraint.secondItem === parentView)
    #expect(constraint.firstAttribute == .top)
    #expect(constraint.secondAttribute == .top)
    #expect(constraint.relation == .equal)
    #expect(constraint.multiplier == 1.0)
    #expect(constraint.constant == 0.0)
    #expect(constraint.priority == .required)
    #expect(constraint.isActive == true)
    #expect(childView.translatesAutoresizingMaskIntoConstraints == false)
  }

  @Test("constraint with custom parameters")
  func testConstraintWithCustomParameters() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    let constraint = childView.constraint(
      .leading,
      equalTo: parentView,
      multiplier: 0.5,
      constant: 10.0,
      priority: .defaultHigh
    )

    #expect(constraint.multiplier == 0.5)
    #expect(constraint.constant == 10.0)
    #expect(constraint.priority == .defaultHigh)
  }

  @Test("constraint defaults to superview when view is nil")
  func testConstraintDefaultsToSuperview() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    let constraint = childView.constraint(.centerX)

    #expect(constraint.secondItem === parentView)
  }

  @Test("constraints with multiple attributes")
  func testConstraintsWithMultipleAttributes() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    let constraints = childView.constraints(
      [.top, .bottom, .leading, .trailing],
      equalTo: parentView,
      constant: 8.0
    )

    #expect(constraints.count == 4)

    let attributes: [NSLayoutConstraint.Attribute] = [.top, .bottom, .leading, .trailing]
    for (index, constraint) in constraints.enumerated() {
      #expect(constraint.firstAttribute == attributes[index])
      #expect(constraint.secondAttribute == attributes[index])
      #expect(constraint.constant == 8.0)
      #expect(constraint.isActive == true)
    }
  }

  @Test("constraint with different attributes")
  func testConstraintWithDifferentAttributes() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    let constraint = childView.constraint(
      .centerX,
      equalTo: parentView,
      attribute: .leading,
      multiplier: 2.0,
      constant: 20.0
    )

    #expect(constraint.firstAttribute == .centerX)
    #expect(constraint.secondAttribute == .leading)
    #expect(constraint.multiplier == 2.0)
    #expect(constraint.constant == 20.0)
    #expect(constraint.isActive == true)
  }

  @Test("constraint with constant value")
  func testConstraintWithConstantValue() {
    let view = UIView()

    let constraint = view.constraint(.width, equalTo: 100.0)

    #expect(constraint.firstItem === view)
    #expect(constraint.secondItem == nil)
    #expect(constraint.firstAttribute == .width)
    #expect(constraint.secondAttribute == .notAnAttribute)
    #expect(constraint.multiplier == 1.0)
    #expect(constraint.constant == 100.0)
    #expect(constraint.isActive == true)
    #expect(view.translatesAutoresizingMaskIntoConstraints == false)
  }

  @Test("constraint with constant value and custom priority")
  func testConstraintWithConstantValueAndCustomPriority() {
    let view = UIView()

    let constraint = view.constraint(
      .height,
      equalTo: 50.0,
      priority: .defaultLow
    )

    #expect(constraint.constant == 50.0)
    #expect(constraint.priority == .defaultLow)
  }

  @Test("translatesAutoresizingMaskIntoConstraints is disabled")
  func testTranslatesAutoresizingMaskIntoConstraintsIsDisabled() {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = true

    _ = view.constraint(.width, equalTo: 100.0)

    #expect(view.translatesAutoresizingMaskIntoConstraints == false)
  }

  @Test("constraint returns discardable result")
  func testConstraintReturnsDiscardableResult() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    // This should compile without warnings about unused result
    childView.constraint(.top, equalTo: parentView)
    childView.constraints([.leading, .trailing], equalTo: parentView)
    childView.constraint(.centerX, equalTo: parentView, attribute: .centerX)
    childView.constraint(.width, equalTo: 100.0)

    #expect(true) // Test passes if compilation succeeds
  }
}

@Suite("UIView Constraint Extension Edge Cases")
@MainActor
struct UIViewConstraintExtensionEdgeCasesTests {

  @Test("constraint with negative constant")
  func testConstraintWithNegativeConstant() {
    let view = UIView()

    let constraint = view.constraint(.width, equalTo: -50.0)

    #expect(constraint.constant == -50.0)
  }

  @Test("multiple constraints on same view")
  func testMultipleConstraintsOnSameView() {
    let parentView = UIView()
    let childView = UIView()
    parentView.addSubview(childView)

    let constraint1 = childView.constraint(.top, equalTo: parentView)
    let constraint2 = childView.constraint(.leading, equalTo: parentView)
    let constraint3 = childView.constraint(.width, equalTo: 100.0)

    #expect(constraint1.isActive == true)
    #expect(constraint2.isActive == true)
    #expect(constraint3.isActive == true)
    #expect(childView.translatesAutoresizingMaskIntoConstraints == false)
  }
}
