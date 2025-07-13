//
//  CornerRadiusMaskViewTests.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import Testing
@testable import DynamicBottomSheet

@Suite("CornerRadiusMaskView Tests")
@MainActor
struct CornerRadiusMaskViewTests {

  @Test("Initialization with radius sets properties correctly")
  func initializationWithRadius() {
    // Given
    let radius: CGFloat = 10.0

    // When
    let maskView = CornerRadiusMaskView(radius: radius)

    // Then
    #expect(maskView.radius == radius)
    #expect(maskView.image != nil)
    #expect(maskView.frame == .zero)
  }

  @Test("Radius property is stored correctly")
  func radiusPropertyStorage() {
    // Given
    let expectedRadius: CGFloat = 15.0

    // When
    let maskView = CornerRadiusMaskView(radius: expectedRadius)

    // Then
    #expect(maskView.radius == expectedRadius)
  }

  @Test("Image is generated with correct dimensions")
  func imageGenerationWithCorrectDimensions() {
    // Given
    let radius: CGFloat = 8.0

    // When
    let maskView = CornerRadiusMaskView(radius: radius)

    // Then
    #expect(maskView.image != nil)

    let expectedSize = CGSize(width: radius * 2 + 1, height: radius * 2 + 1)
    #expect(maskView.image?.size.width == expectedSize.width)
    #expect(maskView.image?.size.height == expectedSize.height)
  }

  @Test("Generated image has correct cap insets for resizing")
  func imageHasCorrectCapInsets() {
    // Given
    let radius: CGFloat = 12.0

    // When
    let maskView = CornerRadiusMaskView(radius: radius)

    // Then
    #expect(maskView.image != nil)

    let image = maskView.image!
    let expectedCapInset = radius + 0.1

    #expect(abs(image.capInsets.top - expectedCapInset) < 0.01)
    #expect(abs(image.capInsets.left - expectedCapInset) < 0.01)
    #expect(abs(image.capInsets.bottom - expectedCapInset) < 0.01)
    #expect(abs(image.capInsets.right - expectedCapInset) < 0.01)
  }

  @Test("Zero radius creates valid mask view")
  func zeroRadiusCreatesValidMaskView() {
    // Given
    let radius: CGFloat = 0.0

    // When
    let maskView = CornerRadiusMaskView(radius: radius)

    // Then
    #expect(maskView.radius == 0.0)
    #expect(maskView.image != nil)
  }

  @Test("Negative radius is handled correctly")
  func negativeRadiusHandling() {
    // Given
    let radius: CGFloat = -5.0

    // When
    let maskView = CornerRadiusMaskView(radius: radius)

    // Then
    #expect(maskView.radius == 0.0)
    #expect(maskView.image != nil)
  }
}

@Suite("UIImage Corner Radius Extension Tests")
@MainActor
struct UIImageCornerRadiusExtensionTests {

  @Test("Image generation creates non-nil image")
  func imageGenerationCreatesValidImage() {
    // Given
    let radius: CGFloat = 10.0
    let corners: UIRectCorner = [.topLeft, .topRight]

    // When
    let image = UIImage.make(byRoundingCorners: corners, radius: radius)

    // Then
    #expect(image != nil)
  }

  @Test("Generated image has expected dimensions")
  func generatedImageHasExpectedDimensions() {
    // Given
    let radius: CGFloat = 15.0
    let corners: UIRectCorner = [.topLeft, .topRight]

    // When
    let image = UIImage.make(byRoundingCorners: corners, radius: radius)

    // Then
    let expectedSize = CGSize(width: radius * 2 + 1, height: radius * 2 + 1)
    #expect(image?.size.width == expectedSize.width)
    #expect(image?.size.height == expectedSize.height)
  }

  @Test("Generated image has correct cap insets")
  func generatedImageHasCorrectCapInsets() {
    // Given
    let radius: CGFloat = 25.0
    let corners: UIRectCorner = [.allCorners]

    // When
    let image = UIImage.make(byRoundingCorners: corners, radius: radius)

    // Then
    #expect(image != nil)

    let expectedCapInset = radius + 0.1
    let capInsets = image!.capInsets

    #expect(abs(capInsets.top - expectedCapInset) < 0.01)
    #expect(abs(capInsets.left - expectedCapInset) < 0.01)
    #expect(abs(capInsets.bottom - expectedCapInset) < 0.01)
    #expect(abs(capInsets.right - expectedCapInset) < 0.01)
  }

  @Test("Different corner combinations produce valid images",
        arguments: [
          UIRectCorner.topLeft,
          UIRectCorner.topRight,
          UIRectCorner.bottomLeft,
          UIRectCorner.bottomRight,
          [.topLeft, .topRight],
          [.bottomLeft, .bottomRight],
          UIRectCorner.allCorners
        ]
  )
  func differentCornerCombinationsProduceValidImages(corners: UIRectCorner) {
    // Given
    let radius: CGFloat = 12.0

    // When
    let image = UIImage.make(byRoundingCorners: corners, radius: radius)

    // Then
    #expect(image != nil)
    #expect(image?.size.width == radius * 2 + 1)
    #expect(image?.size.height == radius * 2 + 1)
  }

  @Test("Image rendering context is properly cleaned up")
  func imageRenderingContextCleanup() {
    // Given
    let radius: CGFloat = 8.0
    let corners: UIRectCorner = [.topLeft, .topRight]

    // When
    let initialContext = UIGraphicsGetCurrentContext()
    let image = UIImage.make(byRoundingCorners: corners, radius: radius)
    let finalContext = UIGraphicsGetCurrentContext()

    // Then
    #expect(image != nil)
    #expect(initialContext == finalContext, "Graphics context should be properly restored")
  }
}
