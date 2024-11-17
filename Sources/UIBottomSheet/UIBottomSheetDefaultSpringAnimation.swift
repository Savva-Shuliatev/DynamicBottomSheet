//
//  UIBottomSheetDefaultSpringAnimation.swift
//  DynamicBottomSheetApp
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import Foundation
import CoreGraphics

extension UIBottomSheet {
  public enum AnimationParameters: Equatable {
    case spring(Spring)
  }
}

public extension UIBottomSheet.AnimationParameters {

  static func spring(mass: CGFloat, stiffness: CGFloat, dampingRatio: CGFloat) -> UIBottomSheet.AnimationParameters {
    return .spring(Spring(mass: mass, stiffness: stiffness, dampingRatio: dampingRatio))
  }
}

internal final class UIBottomSheetDefaultSpringAnimation: UIBottomSheetAnimation {

  init(
    initialOrigin: CGFloat,
    targetOrigin: CGFloat,
    initialVelocity: CGFloat,
    parameters: UIBottomSheet.AnimationParameters,
    onUpdate: @escaping (CGFloat) -> Void,
    completion: @escaping (Bool) -> Void
  ) {
    self.currentOrigin = initialOrigin
    self.currentVelocity = initialVelocity
    self.y = targetOrigin
    self.parameters = parameters
    self.threshold = 0.5
    self.onUpdate = onUpdate
    self.completion = completion

    updateAnimation()
  }

  func invalidate() {
    animation?.invalidate()
  }

  // MARK: - UIBottomSheetAnimation

  var y: CGFloat {
    didSet {
      updateAnimation()
    }
  }

  var isDone: Bool {
    return animation?.running ?? false
  }

  // MARK: - Private

  private var currentOrigin: CGFloat
  private var currentVelocity: CGFloat
  private let parameters: UIBottomSheet.AnimationParameters
  private let threshold: CGFloat
  private let onUpdate: (CGFloat) -> Void
  private let completion: (Bool) -> Void
  private var animation: TimerAnimation?

  private func updateAnimation() {
    guard !isDone else { return }

    animation?.invalidate(withColmpletion: false)

    let to = y
    let timingParameters = makeTimingParameters()

    animation = TimerAnimation(
      animations: { [weak self, timingParameters, threshold] time in
        guard let self = self else {
          return .finish
        }

        self.currentOrigin = to + timingParameters.value(at: time)
        self.onUpdate(self.currentOrigin)

        return timingParameters.amplitude(at: time) < threshold ? .finish : .continue
      },
      completion: { [onUpdate, completion] finished in
        if finished {
          onUpdate(to)
        }
        completion(finished)
      }
    )
  }

  private func makeTimingParameters() -> DampingTimingParameters {
    let from = currentOrigin
    let to = y

    switch parameters {
    case let .spring(spring):
      return SpringTimingParameters(
        spring: spring,
        displacement: from - to,
        initialVelocity: currentVelocity,
        threshold: threshold
      )
    }
  }
}
