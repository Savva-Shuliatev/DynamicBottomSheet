//
//  AllSettingsView.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import SwiftUI
import MapKit
import DynamicBottomSheet

struct AllSettingsView: View {

  @ObservedObject var viewModel: AllSettingsViewModel
  @State private var showMap: Bool = false
  @State private var region = MKCoordinateRegion(
    center: CLLocationCoordinate2D(latitude: 37.3230, longitude: -122.0322),
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  )

  var body: some View {
      NavigationView {
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

            stepperCell("cornerRadius", step: 1, transitionStep: 0.1, value: Binding(
              get: { CGFloat(viewModel.cornerRadius) },
              set: { viewModel.cornerRadius = $0 }
            ))
          }

          Section("Move") {
            Button {
              //viewModel.moveTo?(AllSettingsPositions.top.position)
            } label: {
              Text("Move to top position")
            }

            Button {
              viewModel.moveTo?(AllSettingsPositions.fromTop120.position)
            } label: {
              Text("Move to fromTop(120) position")
            }

            Button {
              viewModel.moveTo?(AllSettingsPositions.fromBottom200.position)
            } label: {
              Text("Move to fromBottom(200) position")
            }

            Button {
              viewModel.moveTo?(AllSettingsPositions.fromBottom60.position)
            } label: {
              Text("Move to fromBottom(60) position")
            }
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
            stepperCell("Opacity", step: 0.1, transitionStep: 0.02, value: Binding(
              get: { Double(viewModel.shadowOpacity) },
              set: { viewModel.shadowOpacity = Float($0) }
            ))
            stepperCell("Offset", step: 0.1, transitionStep: 0.02, value: Binding(
              get: { Double(viewModel.shadowOffset.height) },
              set: { viewModel.shadowOffset = CGSize(width: $0, height: $0) }
            ))
            stepperCell("Radius", step: 0.25, transitionStep: 0.02, value: Binding(
              get: { Double(viewModel.shadowRadius) },
              set: { viewModel.shadowRadius = CGFloat($0) }
            ))
            cell("Path", value: viewModel.shadowPath)
          }

          Section("Bottom bar") {
            Toggle("Is hidden", isOn: Binding(
              get: { viewModel.bottomBarIsHidden },
              set: { viewModel.bottomBarIsHidden = $0 }
            ))
            stepperCell("Height", step: 1, transitionStep: 0.1, value: Binding(
              get: { Double(viewModel.bottomBarHeight) },
              set: { viewModel.bottomBarHeight = CGFloat($0) }
            ))
          }
        }
        .padding(.bottom, max(0, viewModel.height - viewModel.bottomSafeAreaInset))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              withAnimation {
                showMap = true
              }
            } label: {
              Text("Map")
            }
          }

          ToolbarItem(placement: .topBarLeading) {
            Button {
              withAnimation {
                viewModel.closeDidTap()
              }
            } label: {
              Text("Close")
            }
          }
        }
      }
      .overlay {
        if showMap {
          Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
              withAnimation {
                showMap = false
              }
            }
            .transition(.opacity)
        }
      }

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
