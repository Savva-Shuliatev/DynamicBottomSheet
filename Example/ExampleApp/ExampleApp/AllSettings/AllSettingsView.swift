//
//  AllSettingsView.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import SwiftUI

struct AllSettingsView: View {

  @ObservedObject var viewModel: AllSettingsViewModel

  var body: some View {
    List {
      Section {
        cell("y", value: viewModel.y)
        cell("Height", value: viewModel.height)
        cell("bottomSafeAreaInset", value: viewModel.bottomSafeAreaInset)
        cell("bounces", value: viewModel.bounces)
        cell("bouncesFactor", value: viewModel.bouncesFactor)
        cell("prefersGrabberVisible", value: viewModel.prefersGrabberVisible)
        cell("cornerRadius", value: viewModel.cornerRadius)
      }

      Section("Ignores") {
        cell("Top safeArea", value: viewModel.viewIgnoresTopSafeArea)
        cell("Bottom safeArea", value: viewModel.viewIgnoresBottomSafeArea)
        cell("Bottom bar height", value: viewModel.viewIgnoresBottomBarHeight)
      }

      Section("Shadow") {
        cell("Color", value: viewModel.shadowColor)
        cell("Opacity", value: viewModel.shadowOpacity)
        cell("Offset", value: viewModel.shadowOffset)
        cell("Radius", value: viewModel.shadowRadius)
        cell("Path", value: viewModel.shadowPath)
      }

        Section("Bottom bar") {
        cell("Is hidden", value: viewModel.bottomBarIsHidden)
        cell("Height", value: viewModel.bottomBarHeight)
      }
    }
    .padding(.bottom, 60)
  }

  @ViewBuilder
  private func cell<T>(_ title: String, value: T) -> some View {
    HStack {
      Text(title)
      Spacer()
      Text("\(value)")
    }
  }
}
