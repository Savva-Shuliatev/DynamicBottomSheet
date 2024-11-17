//
//  DefaultValuesTests.swift
//  UIBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Testing
@testable import UIBottomSheet
import UIKit

@Suite("Default values Tests")
struct DefaultValuesTests {

  /// After exiting beta, when changing default values,
  /// we should think about implementing a static default setting, like
  ///
  /// extension UIBottomSheet {
  ///   @MainActor
  ///   public struct Defaults {
  ///     public static var bounces = true
  ///   }
  /// }
  ///
  /// For best expirience of library <3

  @Test @MainActor
  func defaultValues() {
    let bottomSheet = UIBottomSheet()

    #expect(bottomSheet.y == 0)
    #expect(bottomSheet.bounces)
    #expect(bottomSheet.bouncesFactor == 0.1)
    #expect(bottomSheet.viewIgnoresTopSafeArea)
    #expect(!bottomSheet.viewIgnoresBottomBarHeight)
    #expect(!bottomSheet.viewIgnoresBottomSafeArea)
    #expect(bottomSheet.scrollingContent == nil)
    #expect(bottomSheet.animationParameters == .spring(.default))
    #expect(bottomSheet.prefersGrabberVisible)
    #expect(bottomSheet.cornerRadius == 10)
    #expect(bottomSheet.shadowColor == UIColor.black.withAlphaComponent(0.5).cgColor)
    #expect(bottomSheet.shadowOpacity == 0.5)
    #expect(bottomSheet.shadowOffset == CGSize(width: 1.5, height: 1.5))
    #expect(bottomSheet.shadowRadius == 3.0)
    #expect(bottomSheet.shadowPath == nil)
    #expect(bottomSheet.bottomBarIsHidden)
    #expect(bottomSheet.bottomBarHeight == 64)
  }

  @Test @MainActor
  func defaultDetentsValues() {
    let bottomSheet = UIBottomSheet()
    #expect(bottomSheet.detents.positions.isEmpty)
    #expect(bottomSheet.detents.bottomBarConnectedPosition == nil)
    #expect(bottomSheet.detents.initialPosition == .fromBottom(0, ignoresSafeArea: true))
  }

  @Test @MainActor
  func realizationValues() {
    let bottomSheet = UIBottomSheet()
    #expect(bottomSheet.anchors.isEmpty)
    #expect(!bottomSheet.didLayoutSubviews)
  }

}


