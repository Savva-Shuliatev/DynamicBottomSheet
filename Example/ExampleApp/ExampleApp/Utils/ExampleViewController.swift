//
//  ExampleViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

// MARK: Just example code

class ExampleViewController: UIViewController {

  init() {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .fullScreen
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addBackButton() {
    let closeButton = UIButton(type: .close)
    closeButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    view.addSubview(closeButton)
    NSLayoutConstraint.activate([
      closeButton.widthAnchor.constraint(equalToConstant: 28),
      closeButton.heightAnchor.constraint(equalToConstant: 28),
      closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
      closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
    ])
  }

  @objc
  private func tapped() {
    dismiss(animated: true)
  }

}


