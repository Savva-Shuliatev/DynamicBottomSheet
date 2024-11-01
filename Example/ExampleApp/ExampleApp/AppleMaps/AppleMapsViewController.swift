//
//  AppleMapsViewController.swift
//  ExampleApp
//
//  Created by Savva Shuliatev on 02.11.2024.
//

import UIKit
import UIBottomSheet
import MapKit

final class AppleMapsViewController: UIViewController {

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
