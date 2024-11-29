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

  @State private var position: RelativePosition = .hidden

  @State private var edgeType: EdgeType = .top

  var body: some View {
    List {
      Section(header: Text("Edge")) {
        Picker("Edge", selection: $edgeType) {
            ForEach(EdgeType.allCases) { edge in
                Text(edge.displayName).tag(edge)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
    }
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
}
