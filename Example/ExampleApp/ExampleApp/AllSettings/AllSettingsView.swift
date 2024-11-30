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
  @State var colorScheme: ColorScheme = .dark

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

          Section("Detents.positions") {
            ForEach(viewModel.positions.indices, id: \.self) { index in
              let position = viewModel.positions[index]

              PositionCell(
                position: position,
                moveAction: {
                  viewModel.moveTo?(position)
                },
                removeAction: {
                  let _ = withAnimation {
                    self.viewModel.positions.remove(at: index)
                  }

                }
              )
            }

            Button {
              viewModel.showAddPosition(availablePosition: false)
            } label: {
              Text("Add")
            }

          }

          Section {
            ForEach(viewModel.availablePositions.indices, id: \.self) { index in
              let position = viewModel.availablePositions[index]

              PositionCell(
                position: position,
                moveAction: {
                  viewModel.moveTo?(position)
                },
                removeAction: {
                  let _ = withAnimation {
                    self.viewModel.availablePositions.remove(at: index)
                  }

                }
              )
            }

            Button {
              viewModel.showAddPosition(availablePosition: true)
            } label: {
              Text("Add")
            }
          } header: {
            Text("Detents.availablePositions")
          } footer: {
            Text("Empty availablePositions means nil for debug")
          }

          Section("Interruptable") {
            VStack {
              Toggle("interrupt by panGesture", isOn: Binding(
                get: { viewModel.panGestureInterrupt },
                set: { viewModel.panGestureInterrupt = $0 }
              ))
              Toggle("interrupt by scrollDragging", isOn: Binding(
                get: { viewModel.scrollDraggingInterrupt },
                set: { viewModel.scrollDraggingInterrupt = $0 }
              ))

              Toggle("interrupt by program", isOn: Binding(
                get: { viewModel.programInterrupt },
                set: { viewModel.programInterrupt = $0 }
              ))
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

          Section("Spring animation") {

            sliderCell(
              title: "mass",
              value: Binding(
                get: { viewModel.mass },
                set: { viewModel.mass = $0 }
              ),
              in: 0...10,
              step: 0.1
            )

            sliderCell(
              title: "stiffness",
              value: Binding(
                get: { viewModel.stiffness },
                set: { viewModel.stiffness = $0 }
              ),
              in: 0...1000,
              step: 10
            )

            sliderCell(
              title: "dampingRatio",
              value: Binding(
                get: { viewModel.dampingRatio },
                set: { viewModel.dampingRatio = $0 }
              ),
              in: 0...1,
              step: 0.01
            )

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

          Section {
            Toggle("Addtitional content", isOn: Binding(
              get: { viewModel.additionalContent },
              set: { viewModel.additionalContent = $0 }
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
        }
        .padding(.bottom, max(0, viewModel.height - viewModel.bottomSafeAreaInset))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
              Button {
                withAnimation {
                  switch colorScheme {
                  case .light:
                    colorScheme = .dark
                  case .dark:
                    colorScheme = .light
                  @unknown default:
                    break
                  }
                }
              } label: {
                Text("Scheme")
              }

              Button {
                withAnimation {
                  showMap = true
                }
              } label: {
                Text("Map")
              }
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
      .colorScheme(colorScheme)
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

}

private struct PositionCell: View {

  let position: RelativePosition

  var moveAction: () -> Void
  var removeAction: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("edge")
        Spacer()
        Text("\(position.edge)")
      }
      HStack {
        Text("ignoresSafeArea")
        Spacer()
        Text("\(position.ignoresSafeArea)")
      }
      HStack {
        Text("offset")
        Spacer()
        Text("\(position.offset)")
      }

      HStack {
        Button {
          moveAction()
        } label: {
          Text("  Move  ")
            .font(.subheadline)
        }
        .buttonStyle(.borderedProminent)

        Button {
          removeAction()
        } label: {
          Text("  Remove  ")
            .font(.subheadline)
        }
        .buttonStyle(.borderedProminent)
      }
    }
  }

}
