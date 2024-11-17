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

  private let closeButton = UIButton(type: .close)

  init() {
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .fullScreen
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func addCloseButton() {
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    view.addSubview(closeButton)

    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
    closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
    closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
    closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }

  @objc
  private func closeButtonTapped() {
    dismiss(animated: true)
  }

}


