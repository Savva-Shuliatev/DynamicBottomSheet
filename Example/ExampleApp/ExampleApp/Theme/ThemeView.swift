//
//  ThemeView.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import SwiftUI

// MARK: Just example

enum Theme: Int, CaseIterable, Sendable {
  case system = 0
  case light
  case dark

  var description: String {
    switch self {
    case .system: return "System"
    case .light: return "Light"
    case .dark: return "Dark"
    }
  }
}

struct ThemeView: View {
  @State private var theme: Theme = .system
  @State private var circleOffset: CGSize = .zero

  var body: some View {
    VStack(spacing: 15) {
      Circle()
        .fill(theme == .system ? Color.red.gradient : Color.blue.gradient)
        .frame(width: 150, height: 150)
        .mask {
          Rectangle()
            .overlay {
              Circle()
                .offset(circleOffset)
                .blendMode(.destinationOut)
            }
        }

      Text("Customize your interface")
        .font(.title2.bold())
        .padding(.top, 25)

      Text("Choose an application theme")
        .multilineTextAlignment(.center)

      HStack(spacing: 0) {
        ForEach(Theme.allCases, id: \.rawValue) { theme in
          Text(theme.description)
            .padding(.vertical, 10)
            .frame(width: 100)
//            .background {
//              ZStack {
//                if self.theme == theme {
//                  Capsule()
//                    .fill(.primary.opacity(0.06))
//                    .matchedGeometryEffect(
//                      id: "ACTIVETAB",
//                      in: animation
//                    )
//                }
//              }
//              .animation(.snappy, value: self.theme)
//            }
//            .contentShape(.rect)
//            .onTapGesture {
//              self.theme = theme
//            }
        }
      }
      .padding(3)
      .background(Color.primary.opacity(0.06), in: .capsule)
      .padding(.top, 20)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .frame(height: 410)
    .background(Color.gray.opacity(0.5))
    .clipShape(.rect(cornerRadius: 30))
  }
}
//
//#Preview {
//  ThemeView()
//}
