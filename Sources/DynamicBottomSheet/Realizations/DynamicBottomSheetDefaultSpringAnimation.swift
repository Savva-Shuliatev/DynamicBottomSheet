//
//  DynamicBottomSheetDefaultSpringAnimation.swift
//  DynamicBottomSheet
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

extension DynamicBottomSheet {
  public enum AnimationParameters: Equatable, Sendable {
    case spring(Spring)
  }
}

public extension DynamicBottomSheet.AnimationParameters {

  static func spring(mass: CGFloat, stiffness: CGFloat, dampingRatio: CGFloat) -> DynamicBottomSheet.AnimationParameters {
    return .spring(Spring(mass: mass, stiffness: stiffness, dampingRatio: dampingRatio))
  }
}

internal final class DynamicBottomSheetDefaultSpringAnimation: DynamicBottomSheetAnimation {

  init(
    initialOrigin: CGFloat,
    targetOrigin: CGFloat,
    initialVelocity: CGFloat,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    parameters: DynamicBottomSheet.AnimationParameters,
    onUpdate: @escaping (CGFloat) -> Void,
    completion: @escaping (Bool) -> Void
  ) {
    self.currentOrigin = initialOrigin
    self.currentVelocity = initialVelocity
    self.y = targetOrigin
    self.interruptTriggers = interruptTriggers
    self.parameters = parameters
    self.threshold = 0.5
    self.onUpdate = onUpdate
    self.completion = completion

    updateAnimation()
  }

  func invalidate() {
    animation?.invalidate()
  }

  // MARK: - DynamicBottomSheetAnimation

  var y: CGFloat {
    didSet {
      updateAnimation()
    }
  }

  var isDone: Bool {
    return animation?.running ?? false
  }

  var interruptTriggers: DynamicBottomSheet.InterruptTrigger

  // MARK: - Private

  private var currentOrigin: CGFloat
  private var currentVelocity: CGFloat
  private let parameters: DynamicBottomSheet.AnimationParameters
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
