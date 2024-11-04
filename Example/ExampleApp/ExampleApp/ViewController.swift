//
//  ViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import SwiftUI

enum Example {
  case appleMaps
  case voiceMemos
  case stocks
  case music
  case googleMaps

  case bottomBar
  case dynamicSettings
  case theme
  case changeScrollContent
  case changeStaticToScrollContent
}

final class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let content = ListView { [weak self] in self?.show($0) }
    let hostingController = UIHostingController(rootView: content)

    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(hostingController.view)
    NSLayoutConstraint.activate([
      hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
      hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
    hostingController.didMove(toParent: self)
  }

  private func show(_ example: Example) {
    switch example {
    case .appleMaps:
      break

    case .voiceMemos:
      break

    case .stocks:
      break

    case .music:
      break

    case .googleMaps:
      break

    case .bottomBar:
      show(BottomBarViewController())

    case .dynamicSettings:
      break

    case .theme:
      break

    case .changeScrollContent:
      break

    case .changeStaticToScrollContent:
      break
    }
  }

  private func show(_ viewController: UIViewController) {
    viewController.modalPresentationStyle = .fullScreen
    present(viewController, animated: true)
  }
}

struct ListView: View {

  var action: (Example) -> Void

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Apps")) {
          Button("Apple Maps", action: show(.appleMaps))
          Button("Voice Memos", action: show(.voiceMemos))
          Button("Stocks", action: show(.stocks))
          Button("Music", action: show(.music))
          Button("Google Maps", action: show(.googleMaps))
        }

        Section(header: Text("Cases")) {
          Button("Bottom bar", action: show(.bottomBar))
          Button("Dynamic settings", action: show(.dynamicSettings))
          Button("Change App theme", action: show(.theme))
          Button("Change scroll content", action: show(.changeScrollContent))
          Button("Change static to scroll content", action: show(.changeStaticToScrollContent))
        }
      }
      .navigationTitle("Examples")
    }
  }

  private func show(_ example: Example) -> () -> Void {
    return { action(example) }
  }
}
