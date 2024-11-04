//
//  BottomBarViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import UIBottomSheet
import MapKit

final class BottomBarViewController: ExampleViewController {

  let bottomSheet = UIBottomSheet()

  override func viewDidLoad() {
    super.viewDidLoad()
    let map = MKMapView()
    view.addSubview(map)
    map.frame = view.bounds

    view.addSubview(bottomSheet)
    bottomSheet.frame = view.bounds

    bottomSheet.bottomBar.backgroundColor = .red
    bottomSheet.bottomBarArea.backgroundColor = .blue

    bottomSheet.detents.initialPosition = .fromTop(100)
    bottomSheet.detents.positions = [.fromTop(100), .middle(), .fromBottom(100)]
  }

}
