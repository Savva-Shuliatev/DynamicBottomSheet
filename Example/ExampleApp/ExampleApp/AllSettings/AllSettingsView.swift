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

        Toggle("bounces", isOn: Binding(
          get: { viewModel.bounces },
          set: { viewModel.bounces = $0 }
        ))

        stepperCell("bouncesFactor", step: 0.1, transitionStep: 0.01, value: Binding(
          get: { CGFloat(viewModel.bouncesFactor) },
          set: { viewModel.bouncesFactor = CGFloat(min(max($0, 0), 0.99)) }
        ))

        Toggle("prefersGrabberVisible", isOn: Binding(
          get: { viewModel.prefersGrabberVisible },
          set: { viewModel.prefersGrabberVisible = $0 }
        ))

        cell("cornerRadius", value: viewModel.cornerRadius)
      }

      Section("Ignores") {
        Toggle("Top safeArea", isOn: Binding(
          get: { viewModel.viewIgnoresTopSafeArea },
          set: { viewModel.viewIgnoresTopSafeArea = $0 }
        ))
        Toggle("Bottom safeArea", isOn: Binding(
          get: { viewModel.viewIgnoresBottomSafeArea },
          set: { viewModel.viewIgnoresBottomSafeArea = $0 }
        ))
        Toggle("Bottom bar height", isOn: Binding(
          get: { viewModel.viewIgnoresBottomBarHeight },
          set: { viewModel.viewIgnoresBottomBarHeight = $0 }
        ))
      }

      Section("Shadow") {
        cell("Color", value: viewModel.shadowColor)
        cell("Opacity", value: viewModel.shadowOpacity)
        cell("Offset", value: viewModel.shadowOffset)
        cell("Radius", value: viewModel.shadowRadius)
        cell("Path", value: viewModel.shadowPath)
      }

        Section("Bottom bar") {
          Toggle("Is hidden", isOn: Binding(
            get: { viewModel.bottomBarIsHidden },
            set: { viewModel.bottomBarIsHidden = $0 }
          ))
        cell("Height", value: viewModel.bottomBarHeight)
      }
    }
    .padding(.bottom, max(0, viewModel.height - viewModel.bottomSafeAreaInset))
  }

  @ViewBuilder
  private func cell<T>(_ title: String, value: T) -> some View {
    HStack {
      Text(title)
      Spacer()
      Text("\(value)")
    }
  }

  @ViewBuilder
  private func stepperCell(_ title: String, step: Double, transitionStep: Double, value: Binding<Double>) -> some View {
    HStack {
      Text(title)
      Spacer()
      StepperView(step: step, transitionStep: transitionStep, value: value)
      Text("\(value.wrappedValue)")
    }
  }

}
