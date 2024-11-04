//
//  ExampleViewController.swift
//  ExampleApp
//
//  Created by Savva Shuliatev on 05.11.2024.
//

import UIKit

class ExampleViewController: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addCloseButton()
  }

  private func addCloseButton() {

  }

}
