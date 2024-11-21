//
//  ThemeViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import DynamicBottomSheet

final class ThemeViewController: UIViewController {

  private lazy var bottomSheet: DynamicBottomSheet = {
    let bottomSheet = DynamicBottomSheet()
    bottomSheet.visibleView.backgroundColor = .clear
    bottomSheet.view.backgroundColor = .green
    bottomSheet.detents.positions = [.fromBottom(410, ignoresSafeArea: true)]
    return bottomSheet
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    view.addSubview(bottomSheet)
    bottomSheet.constraints([.top, .bottom, .leading, .trailing])
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    bottomSheet.detents.move(to: .fromBottom(410, ignoresSafeArea: true))
  }

}
