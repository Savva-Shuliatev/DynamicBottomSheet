//
//  SceneDelegate.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }

    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = ViewController()
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.window?.rootViewController?.present(AllSettingsViewController(), animated: true)
    }
    window?.makeKeyAndVisible()
  }

}
