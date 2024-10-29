//
//  Subscribers.swift
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

internal final class Subscribers<Subscriber> {

  init() {
    self.subscribers = WeakCollection<Subscriber>()
  }

  func subscribe(_ subscriber: Subscriber) {
    subscribers.insert(subscriber)
  }

  func unsubscribe(_ subscriber: Subscriber) {
    subscribers.remove(subscriber)
  }

  func forEach(_ block: (Subscriber) -> Void) {
    subscribers.forEach(block)
  }

  var isEmpty: Bool {
    return subscribers.isEmpty()
  }

  // MARK: - Private

  private var subscribers: WeakCollection<Subscriber>
}
