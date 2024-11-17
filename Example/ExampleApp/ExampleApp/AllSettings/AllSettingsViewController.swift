//
//  AllSettingsViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import SwiftUI
import Combine
import UIBottomSheet

final class AllSettingsViewController: ExampleViewController {

  private let viewModel = AllSettingsViewModel()

  private lazy var bottomSheet: UIBottomSheet = {
    let bottomSheet = UIBottomSheet()
    bottomSheet.detents.subscribe(self)
    bottomSheet.detents.initialPosition = .fromBottom(200)
    bottomSheet.detents.positions = [
      .top(),
      .fromTop(120),
      .fromBottom(200),
      .fromBottom(60)
    ]
    return bottomSheet
  }()

  private var cancellables = Set<AnyCancellable>()

  override func viewDidLoad() {
    super.viewDidLoad()
    add(AllSettingsView(viewModel: viewModel))
    view.addSubview(bottomSheet)
    bottomSheet.constraints([.top, .bottom, .leading, .trailing])
    addCloseButton()
    sink()
  }

  private func sink() {
    viewModel.$bounces.sink { [weak self] in
      self?.bottomSheet.bounces = $0
    }
    .store(in: &cancellables)

    viewModel.$bouncesFactor.sink { [weak self] in
      self?.bottomSheet.bouncesFactor = $0
    }
    .store(in: &cancellables)

    viewModel.$viewIgnoresTopSafeArea.sink { [weak self] in
      self?.bottomSheet.viewIgnoresTopSafeArea = $0
    }
    .store(in: &cancellables)

    viewModel.$viewIgnoresBottomBarHeight.sink { [weak self] in
      self?.bottomSheet.viewIgnoresBottomBarHeight = $0
    }
    .store(in: &cancellables)

    viewModel.$viewIgnoresBottomSafeArea.sink { [weak self] in
      self?.bottomSheet.viewIgnoresBottomSafeArea = $0
    }
    .store(in: &cancellables)

    viewModel.$prefersGrabberVisible.sink { [weak self] in
      self?.bottomSheet.prefersGrabberVisible = $0
    }
    .store(in: &cancellables)

    viewModel.$cornerRadius.sink { [weak self] in
      self?.bottomSheet.cornerRadius = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowColor.sink { [weak self] in
      self?.bottomSheet.shadowColor = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowOpacity.sink { [weak self] in
      self?.bottomSheet.shadowOpacity = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowOffset.sink { [weak self] in
      self?.bottomSheet.shadowOffset = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowRadius.sink { [weak self] in
      self?.bottomSheet.shadowRadius = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowPath.sink { [weak self] in
      self?.bottomSheet.shadowPath = $0
    }
    .store(in: &cancellables)

    viewModel.$bottomBarIsHidden.sink { [weak self] in
      self?.bottomSheet.bottomBarIsHidden = $0
    }
    .store(in: &cancellables)

    viewModel.$bottomBarHeight.sink { [weak self] in
      self?.bottomSheet.updateBottomBarHeight($0)
    }
    .store(in: &cancellables)
  }
}

extension AllSettingsViewController: UIBottomSheetDetentsSubscriber {
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didUpdateY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginAnimation animation: UIBottomSheetAnimation,
    source: UIBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didChangePosition position: RelativePosition,
    source: UIBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {
    viewModel.height = height
    viewModel.bottomSafeAreaInset = bottomSafeAreaInset
  }
}
