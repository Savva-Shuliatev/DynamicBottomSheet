//
//  TimerAnimation.swift
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
import QuartzCore

internal final class TimerAnimation {

  enum TargetState {
    case `continue`
    case finish
  }

  typealias Animations = (_ time: TimeInterval) -> TargetState
  typealias Completion = (_ finished: Bool) -> Void

  private(set) var running: Bool = true

  init(animations: @escaping Animations, completion: Completion? = nil) {
    self.animations = animations
    self.completion = completion

    let proxy = DisplayLinkProxy()
    proxy.target = self

    let displayLink = CADisplayLink(
      target: proxy,
      selector: #selector(DisplayLinkProxy.handleFrame(_:))
    )
    displayLink.add(to: .main, forMode: RunLoop.Mode.common)
    self.displayLink = displayLink
  }

  deinit {
    invalidate()
  }

  func invalidate(withCompletion: Bool = true) {
    guard running else { return }
    running = false
    if withCompletion {
      completion?(false)
    }
    displayLink?.invalidate()
  }

  // MARK: - Private

  private let animations: Animations
  private let completion: Completion?
  private var displayLink: CADisplayLink?

  private var accumulatedTime: TimeInterval = 0

  @MainActor
  @objc fileprivate func handleFrame(_ displayLink: CADisplayLink) {
    guard running else { return }

    let speed = getSpeed()

    let frameDuration = displayLink.targetTimestamp - displayLink.timestamp

    accumulatedTime += frameDuration * Double(speed)

    let targetState = animations(accumulatedTime)

    switch targetState {
    case .continue:
      break
    case .finish:
      running = false
      completion?(true)
      displayLink.invalidate()
    }
  }
}

// MARK: DisplayLinkProxy

private final class DisplayLinkProxy {

  weak var target: TimerAnimation?

  @MainActor
  @objc func handleFrame(_ displayLink: CADisplayLink) {
    target?.handleFrame(displayLink)
  }
}

// MARK: Helpers

extension TimerAnimation {
  @MainActor
  func getSpeed() -> Double {
    let speed: Double

#if DEBUG
    speed = DynamicBottomSheet.slowAnimations ? 0.1 : 1.0
    assert(speed > 0, "Speed of TimerAnimation in DynamicBottomSheet must be > 0")
#else
    speed = 1
#endif

    return speed
  }
}
