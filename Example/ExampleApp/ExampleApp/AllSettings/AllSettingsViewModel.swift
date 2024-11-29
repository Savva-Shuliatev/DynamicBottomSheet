//
//  AllSettingsViewModel.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import DynamicBottomSheet

enum AllSettingsPositions: CaseIterable {
  case top
  case fromTop120
  case fromBottom200
  case fromBottom60

  var position: RelativePosition {
    switch self {
    case .top: return .top()
    case .fromTop120: return .fromTop(120)
    case .fromBottom200: return .fromBottom(200)
    case .fromBottom60: return .fromBottom(60)
    }
  }
}

@MainActor
final class AllSettingsViewModel: ObservableObject {

  var closeAction: (() -> Void)?

  var moveTo: ((RelativePosition) -> Void)?

  @Published var y: CGFloat = 0

  @Published var height: CGFloat = 0

  @Published var bottomSafeAreaInset: CGFloat = 0

  @Published var bounces: Bool = true

  @Published var bouncesFactor: CGFloat = 0.1

  @Published var viewIgnoresTopSafeArea: Bool = true

  @Published var viewIgnoresBottomBarHeight: Bool = false

  @Published var viewIgnoresBottomSafeArea: Bool = false

  @Published var prefersGrabberVisible: Bool = true

  @Published var cornerRadius: CGFloat = 10

  @Published var panGestureInterrupt: Bool = true
  @Published var scrollDraggingInterrupt: Bool = true
  @Published var programInterrupt: Bool = true

  @Published var shadowColor: CGColor? = UIColor.black.withAlphaComponent(0.5).cgColor

  @Published var shadowOpacity: Float = 0.5

  @Published var shadowOffset: CGSize = CGSize(width: 1.5, height: 1.5)

  @Published var shadowRadius: CGFloat = 3.0

  @Published var shadowPath: CGPath?

  @Published var bottomBarIsHidden: Bool = false

  @Published var bottomBarHeight: CGFloat = 64

  @Published var additionalContent: Bool = false

  func closeDidTap() {
    closeAction?()
  }
}
