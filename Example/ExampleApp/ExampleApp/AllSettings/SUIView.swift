//
//  SUIView.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import SwiftUI

struct SUIView: View {
  var body: some View {
    VStack {
      NativeSegmentedControlView()
        .frame(height: 52)

      List {
        ScrollView(.horizontal) {
          HStack {
            ForEach(0..<100) { index in
              Text("horizontal \(index)")
            }
          }
        }
        .frame(height: 56)

        ForEach(0..<1000) { index in
          Text("Cell \(index)")
        }
      }
    }
  }
}

struct NativeSegmentedControlView: View {
    @State private var selectedType: DeliveryType = .standard

    var body: some View {
        VStack(spacing: 20) {
            Text("Выбрано: \(selectedType.rawValue)")
                .font(.headline)

            // 2. Используем Picker
            Picker("Способ доставки", selection: $selectedType) {
                ForEach(DeliveryType.allCases) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.segmented) // 3. Применяем стиль
            .padding()
        }
    }
}

enum DeliveryType: String, CaseIterable, Identifiable {
    case standard = "Стандарт"
    case express = "Экспресс"
    case pickup = "Самовывоз"

    var id: String { self.rawValue }
}
