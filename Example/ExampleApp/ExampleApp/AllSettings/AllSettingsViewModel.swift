//
//  AllSettingsViewModel.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

@MainActor
final class AllSettingsViewModel: ObservableObject {

  var closeAction: (() -> Void)?

  @Published var y: CGFloat = 0

  @Published var height: CGFloat = 0

  @Published var bottomSafeAreaInset: CGFloat = 0

  @Published var bounces: Bool = true

  @Published var bouncesFactor: CGFloat = 0.1

  @Published var viewIgnoresTopSafeArea: Bool = true

  @Published var viewIgnoresBottomBarHeight: Bool = false

  @Published var viewIgnoresBottomSafeArea: Bool = false

  @Published var prefersGrabberVisible: Bool = true

  @Published var cornerRadius: CGFloat = 0

  @Published var shadowColor: CGColor? = UIColor.black.withAlphaComponent(0.5).cgColor

  @Published var shadowOpacity: Float = 0.5

  @Published var shadowOffset: CGSize = CGSize(width: 1.5, height: 1.5)

  @Published var shadowRadius: CGFloat = 3.0

  @Published var shadowPath: CGPath?

  @Published var bottomBarIsHidden: Bool = true

  @Published var bottomBarHeight: CGFloat = 64

  func closeDidTap() {
    closeAction?()
  }
}
