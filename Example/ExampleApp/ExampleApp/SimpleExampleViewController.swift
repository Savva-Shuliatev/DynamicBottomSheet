//
//  SimpleExampleViewController.swift
//  ExampleApp
//
//  Created by Savva Shuliatev on 29.11.2024.
//

import UIKit
import MapKit
import DynamicBottomSheet

final class SimpleExampleViewController: UIViewController {

  private lazy var bottomSheet: DynamicBottomSheet = {
    let bottomSheet = DynamicBottomSheet()
    bottomSheet.detents.positions = [.top(), .middle(), .fromBottom(64)]
    bottomSheet.onFirstAppear = { [weak self] in
      self?.bottomSheet.detents.move(to: .middle())
    }
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
