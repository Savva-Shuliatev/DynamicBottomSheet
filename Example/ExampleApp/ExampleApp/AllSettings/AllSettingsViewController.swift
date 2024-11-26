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
import DynamicBottomSheet

final class AllSettingsViewController: ExampleViewController {

  private let viewModel = AllSettingsViewModel()

  private lazy var bottomSheet: DynamicBottomSheet = {
    let bottomSheet = DynamicBottomSheet()
    bottomSheet.view.backgroundColor = .systemBackground
    bottomSheet.visibleView.backgroundColor = .systemGray
    bottomSheet.bottomBar.view.backgroundColor = .systemGray2.withAlphaComponent(0.35)
    bottomSheet.bottomBar.area.backgroundColor = .systemGray3.withAlphaComponent(0.35)
    bottomSheet.detents.subscribe(self)
    bottomSheet.detents.initialPosition = .fromBottom(200)
    bottomSheet.detents.positions = AllSettingsPositions.allCases.map { $0.position }
    bottomSheet.bottomBar.connectedPosition = .fromBottom(200)
    return bottomSheet
  }()

  private var cancellables = Set<AnyCancellable>()

  override init() {
    super.init()

    viewModel.closeAction = { [weak self] in
      self?.dismiss(animated: true)
    }

    viewModel.moveTo = { [weak self] position in
      self?.bottomSheet.detents.move(to: position)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    add(AllSettingsView(viewModel: viewModel))
    view.addSubview(bottomSheet)
    bottomSheet.constraints([.top, .bottom, .leading, .trailing])
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
      self?.bottomSheet.bottomBar.viewIgnoresBottomBarHeight = $0
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
      self?.bottomSheet.bottomBar.isHidden = $0
    }
    .store(in: &cancellables)

    viewModel.$bottomBarHeight.sink { [weak self] in
      self?.bottomSheet.bottomBar.updateHeight($0)
    }
    .store(in: &cancellables)
  }
}

extension AllSettingsViewController: DynamicBottomSheetDetentsSubscriber {
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didUpdateY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginAnimation animation: DynamicBottomSheetAnimation,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didChangePosition position: RelativePosition,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.height = height
    viewModel.bottomSafeAreaInset = bottomSafeAreaInset
  }
}
