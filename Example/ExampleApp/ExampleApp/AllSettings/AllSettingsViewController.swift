//
//  AllSettingsViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit
import SwiftUI
import Combine
import DynamicBottomSheet

final class AllSettingsViewController: ExampleViewController {

  private let viewModel = AllSettingsViewModel()

  private let contentViewController = TestContentViewController()

  private var bubbleBar: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    view.backgroundColor = .white
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = 10
    return view
  }()
  private let panRecognizer = UIPanGestureRecognizer()

  private lazy var bottomSheet: DynamicBottomSheet = {
    let bottomSheet = DynamicBottomSheet()
    bottomSheet.bottomBar.view.backgroundColor = .systemGray2.withAlphaComponent(0.35)
    bottomSheet.bottomBar.area.backgroundColor = .systemGray3.withAlphaComponent(0.35)
    bottomSheet.detents.subscribe(self)
    bottomSheet.detents.initialPosition = .fromBottom(200)
    bottomSheet.detents.positions = AllSettingsPositions.allCases.map { $0.position }
    bottomSheet.bottomBar.connectedPosition = .fromBottom(200)

    contentViewController.delegate = self
    addChild(contentViewController)
    bottomSheet.view.addSubview(contentViewController.view)
    contentViewController.view.constraints([.top, .bottom, .leading, .trailing])
    contentViewController.didMove(toParent: self)
    bottomSheet.connect(contentViewController)

    return bottomSheet
  }()

  private var cancellables = Set<AnyCancellable>()

  override init() {
    super.init()

    viewModel.closeAction = { [weak self] in
      self?.dismiss(animated: true)
    }

    viewModel.moveTo = { [weak self] position in
      guard let self else { return }

      var interruptTriggers: DynamicBottomSheet.InterruptTrigger = []

      if viewModel.panGestureInterrupt {
        interruptTriggers.insert(.panGesture)
      }

      if viewModel.scrollDraggingInterrupt {
        interruptTriggers.insert(.scrollDragging)
      }

      if viewModel.programInterrupt {
        interruptTriggers.insert(.program)
      }

      self.bottomSheet.detents.move(
        to: position,
        interruptTriggers: interruptTriggers
      )
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    add(AllSettingsView(viewModel: viewModel))
    view.addSubview(bottomSheet)
    bottomSheet.constraints([.top, .bottom, .leading, .trailing])
    sink()

    view.addSubview(bubbleBar)
    bubbleBar.translatesAutoresizingMaskIntoConstraints = false
    bubbleBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    bubbleBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    bubbleBar.heightAnchor.constraint(equalToConstant: 32).isActive = true
    bubbleBar.bottomAnchor.constraint(equalTo: bottomSheet.view.topAnchor, constant: -16).isActive = true
    bubbleBar.addGestureRecognizer(panRecognizer)
    panRecognizer.addTarget(bottomSheet, action: #selector(bottomSheet.handlePanRecognizer))

    let label = UILabel()
    label.text = "Bottom bar on bar area (with 0.35 alpha)"
    bottomSheet.bottomBar.view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.centerYAnchor.constraint(equalTo: bottomSheet.bottomBar.view.centerYAnchor).isActive = true
    label.centerXAnchor.constraint(equalTo: bottomSheet.bottomBar.view.centerXAnchor).isActive = true
  }

  private func sink() {
    viewModel.$bounces.sink { [weak self] in
      self?.bottomSheet.bounces = $0
    }
    .store(in: &cancellables)

    viewModel.$bouncesFactor.sink { [weak self] in
      self?.bottomSheet.bouncesFactor = $0
    }
    .store(in: &cancellables)

    viewModel.$viewIgnoresTopSafeArea.sink { [weak self] in
      self?.bottomSheet.viewIgnoresTopSafeArea = $0
    }
    .store(in: &cancellables)

    viewModel.$viewIgnoresBottomBarHeight.sink { [weak self] in
      self?.bottomSheet.bottomBar.viewIgnoresBottomBarHeight = $0
    }
    .store(in: &cancellables)

    viewModel.$viewIgnoresBottomSafeArea.sink { [weak self] in
      self?.bottomSheet.viewIgnoresBottomSafeArea = $0
    }
    .store(in: &cancellables)

    viewModel.$prefersGrabberVisible.sink { [weak self] in
      self?.bottomSheet.prefersGrabberVisible = $0
    }
    .store(in: &cancellables)

    viewModel.$cornerRadius.sink { [weak self] in
      self?.bottomSheet.cornerRadius = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowColor.sink { [weak self] in
      self?.bottomSheet.shadowColor = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowOpacity.sink { [weak self] in
      self?.bottomSheet.shadowOpacity = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowOffset.sink { [weak self] in
      self?.bottomSheet.shadowOffset = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowRadius.sink { [weak self] in
      self?.bottomSheet.shadowRadius = $0
    }
    .store(in: &cancellables)

    viewModel.$shadowPath.sink { [weak self] in
      self?.bottomSheet.shadowPath = $0
    }
    .store(in: &cancellables)

    viewModel.$bottomBarIsHidden.sink { [weak self] in
      self?.bottomSheet.bottomBar.isHidden = $0
    }
    .store(in: &cancellables)

    viewModel.$bottomBarHeight.sink { [weak self] in
      self?.bottomSheet.bottomBar.updateHeight($0)
    }
    .store(in: &cancellables)

    viewModel.$additionalContent.sink { [weak self] in
      self?.bubbleBar.isHidden = !$0
    }
    .store(in: &cancellables)

    viewModel.$mass.sink { [weak self] mass in
      guard let self else { return }
      self.bottomSheet.animationParameters = .spring(
        mass: self.viewModel.mass,
        stiffness: self.viewModel.stiffness,
        dampingRatio: self.viewModel.dampingRatio
      )
    }
    .store(in: &cancellables)

    viewModel.$stiffness.sink { [weak self] stiffness in
      guard let self else { return }
      self.bottomSheet.animationParameters = .spring(
        mass: self.viewModel.mass,
        stiffness: self.viewModel.stiffness,
        dampingRatio: self.viewModel.dampingRatio
      )
    }
    .store(in: &cancellables)

    viewModel.$dampingRatio.sink { [weak self] dampingRatio in
      guard let self else { return }
      self.bottomSheet.animationParameters = .spring(
        mass: self.viewModel.mass,
        stiffness: self.viewModel.stiffness,
        dampingRatio: self.viewModel.dampingRatio
      )
    }
    .store(in: &cancellables)
  }
}

extension AllSettingsViewController: TestContentViewControllerDelegate {
  func showSecondTableView(_ scrollView: UIScrollView) {
    bottomSheet.connect(scrollView)
  }
  
  func hideSecondTableView() {
    bottomSheet.connect(contentViewController)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    bottomSheet.scrollViewWillBeginDragging(with: scrollView.contentOffset)
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    bottomSheet.scrollViewDidScroll(contentOffset: scrollView.contentOffset, contentInset: scrollView.contentInset)
  }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    bottomSheet.scrollViewWillEndDragging(withVelocity: velocity, targetContentOffset: targetContentOffset)
  }
}

extension TestContentViewController: DynamicBottomSheet.ScrollingContent {
  var contentOffset: CGPoint {
    get { tableView1.contentOffset }
    set { tableView1.contentOffset = newValue }
  }

  func stopScrolling() {
    tableView1.setContentOffset(.zero, animated: false)
  }

}

extension AllSettingsViewController: DynamicBottomSheetDetentsSubscriber {
  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didUpdateY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.y = y
  }

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    willBeginAnimation animation: DynamicBottomSheetAnimation,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    didChangePosition position: RelativePosition,
    source: DynamicBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: DynamicBottomSheet,
    height: CGFloat,
    bottomSafeAreaInset: CGFloat,
    source: DynamicBottomSheet.YChangeSource
  ) {
    viewModel.height = height
    viewModel.bottomSafeAreaInset = bottomSafeAreaInset
  }
}
