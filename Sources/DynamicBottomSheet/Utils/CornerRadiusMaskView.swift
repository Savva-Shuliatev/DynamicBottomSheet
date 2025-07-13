//
//  CornerRadiusMaskView.swift
//  DynamicBottomSheet
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import UIKit

/// A view that displays a mask with rounded top corners
///
/// This image view uses a generated rounded corner image as its content to create
/// a visual mask effect. The view specifically rounds the top-left and top-right corners
/// using the `UIImage.make(byRoundingCorners:radius:)` method.
///
/// - Note: The radius value is automatically clamped to be non-negative
internal final class CornerRadiusMaskView: UIImageView {
  
  let radius: CGFloat

  init(radius: CGFloat) {
    let radius = max(0, radius)
    self.radius = radius
    super.init(frame: .zero)
    image = UIImage.make(byRoundingCorners: [.topLeft, .topRight], radius: radius)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UIImage {
  /// Creates a resizable image with rounded corners
  ///
  /// This method generates a white image with specified rounded corners that can be used
  /// as a background or mask for UI elements. The returned image is configured for stretching
  /// with proper cap insets.
  ///
  /// - Parameters:
  ///   - corners: The corners to round (e.g., `.topLeft`, `.allCorners`)
  ///   - radius: The corner radius in points
  /// - Returns: A resizable image with rounded corners, or `nil` if generation fails
  ///
  /// - Note: The radius value is automatically clamped to be non-negative
  @MainActor
  internal static func make(byRoundingCorners corners: UIRectCorner, radius: CGFloat) -> UIImage? {
    let radius = max(0, radius)
    let rect = CGRect(origin: .zero, size: CGSize(width: radius * 2 + 1, height: radius * 2 + 1))
    let radii = CGSize(width: radius, height: radius)
    let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
    let capInset: CGFloat = radius + 0.1
    let capInsets = UIEdgeInsets(top: capInset, left: capInset, bottom: capInset, right: capInset)

    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    defer {
      UIGraphicsEndImageContext()
    }

    UIColor.white.setStroke()
    path.fill()

    return UIGraphicsGetImageFromCurrentImageContext()?.resizableImage(withCapInsets: capInsets)
  }
}
