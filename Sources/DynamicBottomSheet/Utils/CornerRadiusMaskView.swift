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

internal final class CornerRadiusMaskView: UIImageView {
  
  let radius: CGFloat

  init(radius: CGFloat) {
    self.radius = radius
    super.init(frame: .zero)
    image = UIImage.make(byRoundingCorners: [.topLeft, .topRight], radius: radius)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension UIImage {
  @MainActor
  static func make(byRoundingCorners corners: UIRectCorner, radius: CGFloat) -> UIImage? {
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
