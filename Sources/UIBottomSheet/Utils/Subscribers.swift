//
//  Subscribers.swift
//  DynamicBottomSheetApp
//
//  Created by Savva Shuliatev.
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
