//
//  File.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import Testing
@testable import DynamicBottomSheet

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
