//
//  AppleMapsViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import DynamicBottomSheet
import MapKit

final class AppleMapsViewController: ExampleViewController {

  private let mapView = MKMapView(frame: .zero)
  private let bottomSheet = DynamicBottomSheet()

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
