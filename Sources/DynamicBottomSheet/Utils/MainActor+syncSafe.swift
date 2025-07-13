//
//  MainActor+syncSafe.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation

extension MainActor {
  @discardableResult
  public static func syncSafe<T: Sendable>(_ action: @MainActor () -> T) -> T {
    Thread.isMainThread
    ? MainActor.assumeIsolated(action)
    : DispatchQueue.main.sync(execute: action)
  }
}
