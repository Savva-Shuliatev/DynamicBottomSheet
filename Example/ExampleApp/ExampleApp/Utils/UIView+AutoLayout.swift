//
//  UIView+AutoLayout.swift
//  DynamicBottomSheet
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import UIKit

internal extension UIView {

  @discardableResult
  func constraint(
    _ attribute: NSLayoutConstraint.Attribute,
    equalTo view: UIView? = nil,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    if translatesAutoresizingMaskIntoConstraints {
      translatesAutoresizingMaskIntoConstraints = false
    }

    let constraint = NSLayoutConstraint(
      item: self,
      attribute: attribute,
      relatedBy: .equal,
      toItem: view ?? superview!,
      attribute: attribute,
      multiplier: multiplier,
      constant: constant
    )

    constraint.priority = priority
    constraint.isActive = true

    return constraint
  }

  @discardableResult
  func constraints(
    _ attributes: [NSLayoutConstraint.Attribute],
    equalTo view: UIView? = nil,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> [NSLayoutConstraint] {
    return attributes.map {
      constraint(
        $0,
        equalTo: view,
        multiplier: multiplier,
        constant: constant,
        priority: priority
      )
    }
  }

  @discardableResult
  func constraint(
    _ attribute: NSLayoutConstraint.Attribute,
    equalTo view: UIView? = nil,
    attribute toAttribute: NSLayoutConstraint.Attribute,
    multiplier: CGFloat = 1,
    constant: CGFloat = 0,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    if translatesAutoresizingMaskIntoConstraints {
      translatesAutoresizingMaskIntoConstraints = false
    }

    let constraint = NSLayoutConstraint(
      item: self,
      attribute: attribute,
      relatedBy: .equal,
      toItem: view ?? superview!,
      attribute: toAttribute,
      multiplier: multiplier,
      constant: constant
    )

    constraint.priority = priority
    constraint.isActive = true

    return constraint
  }

  @discardableResult
  func constraint(
    _ attribute: NSLayoutConstraint.Attribute,
    equalTo value: CGFloat,
    priority: UILayoutPriority = .required
  ) -> NSLayoutConstraint {
    if translatesAutoresizingMaskIntoConstraints {
      translatesAutoresizingMaskIntoConstraints = false
    }

    let constraint = NSLayoutConstraint(
      item: self,
      attribute: attribute,
      relatedBy: .equal,
      toItem: nil,
      attribute: .notAnAttribute,
      multiplier: 0,
      constant: value
    )

    constraint.priority = priority
    constraint.isActive = true

    return constraint
  }
}
