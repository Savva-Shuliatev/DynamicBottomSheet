//
//  AppleMapsViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import UIBottomSheet
import MapKit

final class AppleMapsViewController: ExampleViewController {

  private let mapView = MKMapView(frame: .zero)
  private let bottomSheet = UIBottomSheet()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupMap()
    setupBottomSheet()
  }
}

extension AppleMapsViewController {
  func setupMap() {
    view.addSubview(mapView)
    mapView.frame = view.bounds
  }

  func setupBottomSheet() {
    view.addSubview(bottomSheet)
  }
}
