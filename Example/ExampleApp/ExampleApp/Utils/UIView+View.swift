//
//  UIView+View.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import SwiftUI

extension UIViewController {
  /// Method to add a SwiftUI View as a child controller and set its constraints to fill the screen.
  /// - Parameters:
  ///   - swiftUIView: The SwiftUI View to be added.
  public func add<Content: View>(_ swiftUIView: Content) {
    let hostingController = UIHostingController(rootView: swiftUIView)
    
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)
    hostingController.didMove(toParent: self)
    
    NSLayoutConstraint.activate([
      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
