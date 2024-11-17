//
//  ThemeViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import UIBottomSheet

final class ThemeViewController: UIViewController {

  private lazy var bottomSheet: UIBottomSheet = {
    let bottomSheet = UIBottomSheet()
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
