//
//  File.swift
//  DynamicBottomSheet
//
//  Created by Savva Shuliatev on 18.12.2024.
//

import Testing
@testable import DynamicBottomSheet
import UIKit

@Suite("Grabber Tests")
@MainActor
struct GrabberTests {

  @Test
  func grabberVisible() {
    let bottomSheet = DynamicBottomSheet()
    bottomSheet.grabber.isHidden = !bottomSheet.prefersGrabberVisible
    bottomSheet.prefersGrabberVisible = !bottomSheet.prefersGrabberVisible
    bottomSheet.grabber.isHidden = !bottomSheet.prefersGrabberVisible
  }
}
