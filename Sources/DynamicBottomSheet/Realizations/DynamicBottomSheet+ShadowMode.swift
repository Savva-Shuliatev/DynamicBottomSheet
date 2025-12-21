//
//  DynamicBottomSheet+ShadowMode.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation

extension DynamicBottomSheet {
  public enum ShadowMode: Equatable {

    /// The shadow is calculated automatically by the GPU based on the layer's alpha channel.
    ///
    /// Use this mode if your view has complex transparent elements or "holes" inside.
    /// - Note: This triggers **Off-screen rendering**, which is expensive and may cause FPS drops during animation.
    /// - Behavior: If `shadowPath` property is `nil`, `layer.shadowPath` is set to `nil`.
    case automatic

    /// The shadow is rendered using a pre-calculated path matching the `visibleView` frame and corner radius.
    ///
    /// Use this mode for opaque views to achieve 60 FPS scrolling and animations.
    /// - Note: Highly optimized (CPU calculation). The shadow will be a solid shape, ignoring any transparency inside the view.
    /// - Behavior: If `shadowPath` property is `nil`, `layer.shadowPath` is updated automatically in `layoutSubviews`.
    case optimized
  }
}
