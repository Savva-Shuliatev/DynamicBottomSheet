//
//  StepperView.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import SwiftUI

struct StepperView: View {

  enum Process {
    case pozitive
    case negative

    var systemName: String {
      switch self {
      case .pozitive: return "plus"
      case .negative: return "minus"
      }
    }
  }

  let step: Double
  let transitionStep: Double
  @Binding var value: Double
  @State private var onProcessing: Process?

  var body: some View {
    HStack {
      StepperButton(process: .negative, step: step, transitionStep: transitionStep, value: $value)
      StepperButton(process: .pozitive, step: step, transitionStep: transitionStep, value: $value)
    }
  }

  private struct StepperButton: View {

    let process: Process
    let step: Double
    let transitionStep: Double
    @Binding var value: Double
    @State private var selected: Bool = false
    @State private var onProcess: Bool = false
    @State private var timer: Timer? = nil

    var body: some View {
      Image(systemName: process.systemName)
        .resizable()
        .frame(width: 18, height: process == .pozitive ? 18 : 2)
        .font(.title)
        .foregroundColor(selected ? .black.opacity(0.35) : .black)
        .frame(width: 36, height: 36)
        .background(selected ? Color.gray.opacity(0.1) : Color.gray.opacity(0.35))
        .cornerRadius(8)
        .onLongPressGesture(
          minimumDuration: 0.3
        ) {
          onProcess = true
          startTimer()
          } onPressingChanged: { onStart in
            if onStart {
              selected = true
            } else {

              if !onProcess {
                switch process {
                case .pozitive:
                  value += step

                case .negative:
                  value -= step
                }
              }

              onProcess = false
              selected = false
              stopTimer()
            }
          }
          .animation(.easeInOut(duration: 0.15), value: selected)
    }

    private func startTimer() {
      timer?.invalidate()
      timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
        switch process {
        case .pozitive:
          value += transitionStep

        case .negative:
          value -= transitionStep
        }
      }
    }

    private func stopTimer() {
      timer?.invalidate()
      timer = nil
    }
  }

}
