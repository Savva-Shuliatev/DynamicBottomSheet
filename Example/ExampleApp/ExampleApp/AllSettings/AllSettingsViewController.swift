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

  override func viewDidLoad() {
    super.viewDidLoad()
    add(AllSettingsView(viewModel: viewModel))
    view.addSubview(bottomSheet)
    bottomSheet.constraints([.top, .bottom, .leading, .trailing])
    addCloseButton()
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
