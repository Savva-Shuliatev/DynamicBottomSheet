//
//  SimpleExampleViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import MapKit
import DynamicBottomSheet

enum ExamplePosition {
  case top
  case proportion
  case fromBottom
}

final class SimpleExampleViewController: UIViewController {

  private lazy var bottomSheet: DynamicBottomSheet = {
    let bottomSheet = DynamicBottomSheet()
    bottomSheet.detents.positions = [.top(), .proportion(0.6), .fromBottom(100)]
    bottomSheet.detents.initialPosition = .top()
    return bottomSheet
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(bottomSheet)
    bottomSheet.frame = view.bounds

    addMap()
    addTitleToBottomSheet()
  }

  private func addMap() {
    let mapView = MKMapView()
    view.insertSubview(mapView, at: 0)
    mapView.frame = view.bounds
  }

  private func addTitleToBottomSheet() {
    let titleLabel = UILabel()
    titleLabel.text = "Hello, DynamicBottomSheet!"
    titleLabel.font = .boldSystemFont(ofSize: 24)

    bottomSheet.view.addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: bottomSheet.view.topAnchor, constant: 24).isActive = true
    titleLabel.centerXAnchor.constraint(equalTo: bottomSheet.view.centerXAnchor).isActive = true
  }

}
