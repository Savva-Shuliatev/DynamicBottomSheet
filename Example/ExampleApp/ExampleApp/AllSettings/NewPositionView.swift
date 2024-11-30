//
//  NewPositionView.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import SwiftUI
import DynamicBottomSheet

struct NewPositionView: View {

  @Environment(\.presentationMode) var presentationMode

  @ObservedObject var viewModel: AllSettingsViewModel

  @State private var position: RelativePosition = .hidden

  @State private var edgeType: EdgeType = .top
  @State private var ignoresSafeArea: Bool = false
  @State private var offset: CGFloat = .zero
  @State private var proportion: Double = 1

  var body: some View {
    List {
      Section(header: Text("Edge")) {
        Picker("Edge", selection: $edgeType) {
          ForEach(EdgeType.allCases) { edge in
            Text(edge.displayName)
              .tag(edge)
          }
        }
      }

      Section {
        if edgeType != .hidden {
          Picker("ignoresSafeArea", selection: $ignoresSafeArea) {
            ForEach([true, false], id: \.self) { ignoresSafeArea in
              Text(ignoresSafeArea ? "Yes" : "No")
                .tag(ignoresSafeArea)
            }
          }
        }

        if edgeType.hasOffset {
          sliderCell(
            title: "offset",
            value: $offset,
            in: -500...500,
            step: 1
          )
        }

        if edgeType == .proportion {
          sliderCell(
            title: "proportion",
            value: $proportion,
            in: -0...1,
            step: 0.01
          )
        }
      }

      Button {
        create()
      } label: {
        Text("Add")
      }
      .buttonBorderShape(.roundedRectangle)
    }
  }

  @ViewBuilder
  private func sliderCell<V: BinaryFloatingPoint>(
    title: String,
    value: Binding<V>,
    in bounds: ClosedRange<V> = 0...1,
    step: V.Stride = 1
  ) -> some View where V.Stride: BinaryFloatingPoint {
    VStack {
      Text("\(title) = \(value.wrappedValue)")

      HStack {
        Text("\(bounds.lowerBound)")
          .frame(width: 48)

        Slider(value: value, in: bounds, step: step)

        Text("\(bounds.upperBound)")
          .frame(width: 48)
      }
    }
  }

  func create() {
    let position: RelativePosition

    switch edgeType {
    case .top:
      position = .top(ignoresSafeArea: ignoresSafeArea)
    case .fromTop:
      position = .fromTop(offset, ignoresSafeArea: ignoresSafeArea)
    case .middle:
      position = .middle(offset: offset, withSafeArea: ignoresSafeArea)
    case .fromBottom:
      position = .fromBottom(offset, ignoresSafeArea: ignoresSafeArea)
    case .bottom:
      position = .bottom(ignoresSafeArea: ignoresSafeArea)
    case .hidden:
      position = .hidden
    case .proportion:
      position = .proportion(
        proportion,
        offset: offset,
        withSafeArea: ignoresSafeArea
      )
    }

    withAnimation {
      viewModel.positions.append(position)
    }

    presentationMode.wrappedValue.dismiss()
  }
}

private enum EdgeType: String, CaseIterable, Identifiable {
  case top
  case fromTop
  case middle
  case fromBottom
  case bottom
  case hidden
  case proportion

  var id: String { self.rawValue }

  var displayName: String { rawValue }

  var hasOffset: Bool {
    switch self {
    case .fromTop, .middle, .fromBottom, .proportion:
      return true
    default:
      return false
    }
  }
}
