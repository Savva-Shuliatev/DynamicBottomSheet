//
//  AllSettingsViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import SwiftUI

final class AllSettingsViewController: ExampleViewController {

  private let viewModel = AllSettingsViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    add(AllSettingsView(viewModel: viewModel))
  }
}
