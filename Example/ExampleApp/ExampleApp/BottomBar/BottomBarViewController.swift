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

  private lazy var bottomSheet: UIBottomSheet = {
    let bottomSheet = UIBottomSheet()
    return bottomSheet
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    let map = MKMapView()
    view.addSubview(map)
    map.frame = view.bounds

    view.addSubview(bottomSheet)
    bottomSheet.frame = view.bounds

    bottomSheet.bottomBar.backgroundColor = .red.withAlphaComponent(0.35)
    bottomSheet.bottomBarArea.backgroundColor = .blue.withAlphaComponent(0.35)

    bottomSheet.view.backgroundColor = .yellow

    bottomSheet.viewIgnoresTopSafeArea = true

    bottomSheet.detents.initialPosition = .fromBottom(200)
    bottomSheet.detents.positions = [.top(), .fromTop(120), .fromBottom(200), .fromBottom(60)]
    bottomSheet.detents.bottomBarConnectedPosition = .fromBottom(200)
  }

}
