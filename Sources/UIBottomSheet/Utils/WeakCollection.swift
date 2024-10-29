//
//  WeakCollection.swift
//  DynamicBottomSheetApp
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

internal struct WeakCollection<T> {

  private var elements: ContiguousArray<Box> = []

  func forEach(_ block: (T) -> Void) {
    for elem in elements {
      if let obj = elem.object as? T {
        block(obj)
      }
    }
  }

  mutating func insert(_ elem: T) {
    removeNilElements()
    if index(of: elem) == nil {
      elements.append(Box(elem as AnyObject))
    }
  }

  mutating func remove(_ elem: T) {
    removeNilElements()
    if let index = index(of: elem) {
      elements.remove(at: index)
    }
  }

  mutating func isEmpty() -> Bool {
    removeNilElements()
    return elements.isEmpty
  }

  // MARK: - Private

  private class Box {
    weak var object: AnyObject?

    init(_ object: AnyObject) {
      self.object = object
    }
  }

  private mutating func removeNilElements() {
    elements = elements.filter { $0.object != nil }
  }

  private func index(of element: T) -> Int? {
    return elements.firstIndex(where: { $0.object === element as AnyObject })
  }
}

