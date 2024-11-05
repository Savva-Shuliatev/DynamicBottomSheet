//
//  UIBottomSheet.swift
//  DynamicBottomSheetApp
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import UIKit

/// UIBottomSheetAnimation allows to control y during animation.
@MainActor
public protocol UIBottomSheetAnimation: AnyObject {
  var y: CGFloat { get set }
  var isDone: Bool { get }
}

@MainActor
public protocol UIBottomSheetSubscriber: AnyObject {
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  )
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didUpdateY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  )
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  )
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginAnimation animation: UIBottomSheetAnimation,
    source: UIBottomSheet.YChangeSource
  )
}

open class UIBottomSheet: UIView {

  open lazy private(set) var detents = Detents(bottomSheet: self)

  open private(set) var y: CGFloat = 0 {
    didSet {
      visibleViewYConstraint?.constant = y
    }
  }

  /// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
  open var bounces: Bool = true

  open var bouncesFactor: CGFloat = 0.1

  open var viewIgnoresTopSafeArea: Bool = true {
    didSet {
      guard didLayoutSubviews else { return }
      layoutSubviews()
    }
  }

  open var viewIgnoresBottomBarHeight: Bool = false {
    didSet {
      guard didLayoutSubviews else { return }
      layoutSubviews()
    }
  }

  open var viewIgnoresBottomSafeArea: Bool = false {
    didSet {
      guard didLayoutSubviews else { return }
      layoutSubviews()
    }
  }

  open weak var scrollingContent: ScrollingContent?

  /// Animation parameters for the transitions between anchors
  open var animationParameters: AnimationParameters = .spring(.default)

  public let visibleView = UIView()
  public let view = UIView()
  public let bottomBarArea = UIView()
  public let bottomBar = UIView()

  public let grabber: UIView = {
    let grabber = UIView()
    grabber.backgroundColor = .tertiaryLabel
    grabber.layer.cornerRadius = 2.5
    return grabber
  }()

  open var prefersGrabberVisible = true {
    didSet {
      grabber.isHidden = !prefersGrabberVisible
    }
  }

  open var cornerRadius: CGFloat = 10 {
    didSet {
      guard didLayoutSubviews else { return }
      updateCornerRadius()
    }
  }

  open var shadowColor: CGColor? = UIColor.black.withAlphaComponent(0.5).cgColor {
    didSet {
      guard didLayoutSubviews else { return }
      layer.shadowColor = shadowColor
    }
  }

  open var shadowOpacity: Float = 0.5 {
    didSet {
      guard didLayoutSubviews else { return }
      layer.shadowOpacity = shadowOpacity
    }
  }

  open var shadowOffset = CGSize(width: 1.5, height: 1.5) {
    didSet {
      guard didLayoutSubviews else { return }
      layer.shadowOffset = shadowOffset
    }
  }

  open var shadowRadius: CGFloat = 3.0 {
    didSet {
      guard didLayoutSubviews else { return }
      layer.shadowRadius = shadowRadius
    }
  }

  open var shadowPath: CGPath? {
    didSet {
      guard didLayoutSubviews else { return }
      layer.shadowPath = shadowPath
    }
  }

  open private(set) var bottomBarHeight: CGFloat = 64 {
    didSet {
      bottomBarHeightConstraint?.constant = bottomBarHeight
    }
  }

  internal var anchors: [CGFloat] = []

  internal var didLayoutSubviews = false

  private var anchorLimits: ClosedRange<CGFloat>? {
    if let min = anchors.min(), let max = anchors.max() {
      return min...max
    } else {
      return nil
    }
  }

  private var visibleViewYConstraint: NSLayoutConstraint?
  private var viewTopConstraint: NSLayoutConstraint?
  private var viewHeightConstraint: NSLayoutConstraint?

  private var bottomBarHeightConstraint: NSLayoutConstraint?
  private var bottomBarAreaHeightConstraint: NSLayoutConstraint?

  private var panRecognizerState: PanRecognizerState = .empty
  private let panRecognizer = UIPanGestureRecognizer()

  private var scrollingState: ScrollingState = .empty
  private var scrollingListening: Bool = true
  private var scrollingOffsetUnderLastAnchor: CGFloat = 0

  private var yAnimation: UIBottomSheetDefaultSpringAnimation?

  private var subscribers = Subscribers<UIBottomSheetSubscriber>()

  // MARK: - Init

  public init() {
    super.init(frame: .zero)
    setupUI()
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UIView

  open override func layoutSubviews() {
    super.layoutSubviews()

    if !didLayoutSubviews {
      didLayoutSubviews = true

      setInitialLayout()
      anchors = detents.positions.map { detents.y(for: $0) }
      updateCornerRadius()

      layer.shadowColor = shadowColor
      layer.shadowOpacity = shadowOpacity
      layer.shadowOffset = shadowOffset
      layer.shadowRadius = shadowRadius
      layer.shadowPath = shadowPath
    }

    updateViewHeight()
    updateViewTopAnchor()
  }

  override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let visibleRect = CGRect(
      x: 0.0,
      y: y,
      width: bounds.width,
      height: bounds.height - y
    )
    return visibleRect.contains(point)
  }

  // MARK: - Public methods

  open func scroll(to newY: CGFloat, animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
    sendWillBeginUpdatingY(with: .program)
    move(to: newY, source: .program, animated: animated, completion: completion)
  }

  open func updateBottomBarHeight(_ height: CGFloat) {
    bottomBarHeight = max(height, 0)
    updateBottomBarAreaHeight()
    if !didLayoutSubviews { layoutSubviews() }
  }

  open func subscribe(_ subscriber: UIBottomSheetSubscriber) {
    subscribers.subscribe(subscriber)
  }

  open func unsubscribe(_ subscriber: UIBottomSheetSubscriber) {
    subscribers.unsubscribe(subscriber)
  }
}

// MARK: Setup UI

extension UIBottomSheet {
  private func setupUI() {
    visibleView.backgroundColor = .systemBackground
    view.backgroundColor = .systemBackground
    bottomBarArea.backgroundColor = .systemBackground
    bottomBar.backgroundColor = .systemBackground

    addSubview(visibleView)
    visibleView.addSubview(view)
    visibleView.addSubview(grabber)
    addSubview(bottomBarArea)
    bottomBarArea.addSubview(bottomBar)

    view.constraints([.leading, .trailing])

    grabber.constraint(.top, constant: 5)
    grabber.constraint(.centerX)
    grabber.constraint(.height, equalTo: 5)
    grabber.constraint(.width, equalTo: 36)

    visibleView.addGestureRecognizer(panRecognizer)
    panRecognizer.addTarget(self, action: #selector(handlePanRecognizer))
  }

  private func setInitialLayout() {
    let initialY = detents.y(for: detents.initialPosition)
    visibleViewYConstraint = visibleView.constraint(.top, constant: initialY)
    updateY(initialY, source: .program)
    viewTopConstraint = view.constraint(.top, constant: 0)
    viewHeightConstraint = view.constraint(.height, equalTo: updateViewHeight())
    visibleView.constraints([.leading, .trailing, .bottom])

    bottomBarArea.constraints([.leading, .trailing, .bottom])
    bottomBarAreaHeightConstraint = bottomBarArea.constraint(.height, equalTo: updateBottomBarAreaHeight())

    bottomBar.constraints([.leading, .trailing, .top])
    bottomBarHeightConstraint = bottomBar.constraint(.height, equalTo: bottomBarHeight)
  }

  private func updateCornerRadius() {
    guard didLayoutSubviews else { return }

    if cornerRadius > 0 {
      visibleView.mask = CornerRadiusMaskView(radius: cornerRadius)
      visibleView.mask?.frame = bounds
    } else {
      visibleView.mask = nil
    }
  }
}

// MARK: Pan Recognizer

extension UIBottomSheet {

  private enum PanRecognizerState: Equatable {
    case empty
    case dragging(initialY: CGFloat)
  }

  @objc private func handlePanRecognizer(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .began:
      stopYAnimation()
      panRecognizerState = .dragging(initialY: y)
      sendWillBeginUpdatingY(with: .panGestureInteraction)

    case .changed:
      let translation = sender.translation(in: visibleView)

      if case let .dragging(initialY) = panRecognizerState {
        let newY = clampY(initialY + translation.y)
        updateY(newY, source: .panGestureInteraction)
      }

    case .ended:
      panRecognizerState = .empty
      let velocity = sender.velocity(in: visibleView).y / 1000
      moveYToTheNearestAnchor(with: velocity, source: .panGestureInteraction)

    case .cancelled, .failed:
      panRecognizerState = .empty
      sendDidEndUpdatingY(with: .panGestureInteraction)

    case .possible:
      break

    @unknown default:
      assertionFailure("Unknown pan gesture state: \(sender.state)")
    }
  }

  private func clampY(_ y: CGFloat) -> CGFloat {
    guard let limits = anchorLimits else { return y }

    if !bounces {
      return y.clamped(to: limits)
    }

    if y < limits.lowerBound {
      let diff = limits.lowerBound - y
      let dim = abs(limits.lowerBound)
      return limits.lowerBound - Rubber.bandClamp(diff, coeff: bouncesFactor, dim: dim)
    } else if y > limits.upperBound {
      let diff = y - limits.upperBound
      let dim = abs(bounds.height - limits.upperBound)
      return limits.upperBound + Rubber.bandClamp(diff, coeff: bouncesFactor, dim: dim)
    } else {
      return y
    }
  }
}

// MARK: Scroll integration

extension UIBottomSheet {

  @MainActor
  public protocol ScrollingContent: AnyObject {
    var contentOffset: CGPoint { get set }
    func stopScrolling()
  }

  private enum ScrollingState: Equatable {
    case empty
    case dragging(lastContentOffset: CGPoint)
  }

  func scrollViewWillBeginDragging(with contentOffset: CGPoint) {
    guard scrollingListening else { return }
    scrollingState = .dragging(lastContentOffset: contentOffset)
    stopYAnimation()
    sendWillBeginUpdatingY(with: .scrollDragging)
  }

  func scrollViewDidScroll(contentOffset: CGPoint, contentInset: UIEdgeInsets) {
    guard
      scrollingListening,
      case let .dragging(lastContentOffset) = scrollingState
    else {

      if scrollingListening {
        if contentOffset.y < 0 {
          scrollingContent?.stopScrolling()
        }
      }

      return
    }

    guard let limits = anchorLimits else { return }

    let diff = lastContentOffset.y - contentOffset.y

    if (
      diff < 0 &&
      contentOffset.y > -contentInset.top &&
      y.isGreater(than: limits.lowerBound, eps: Self.originEps)
    ) || (
      diff > 0 && contentOffset.y < -contentInset.top &&
      y.isLess(than: limits.upperBound, eps: Self.originEps)
    ) {
      // Drop contentOffset changing
      scrollingListening = false
      if diff > 0 {
        scrollingContent?.contentOffset.y = contentInset.top
      } else {
        scrollingContent?.contentOffset.y += diff
      }
      scrollingListening = true


      let newY = (y + diff).clamped(to: limits)

      updateY(newY, source: .scrollDragging)

      if let scrollingContent {
        scrollingState = .dragging(lastContentOffset: scrollingContent.contentOffset)
      }

    } else if diff > 0, y >= 771 {

      scrollingListening = false
      scrollingContent?.contentOffset.y = contentInset.top
      scrollingListening = true

      let newY = clampY(y + scrollingOffsetUnderLastAnchor + diff)
      scrollingOffsetUnderLastAnchor += diff
      updateY(newY, source: .scrollDragging)
    } else {
      if let scrollingContent {
        scrollingState = .dragging(lastContentOffset: scrollingContent.contentOffset)
      }
    }
  }

  func scrollViewWillEndDragging(
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>?
  ) {
    guard scrollingListening else { return }
    scrollingState = .empty
    scrollingOffsetUnderLastAnchor = 0

    guard let limits = anchorLimits, limits.contains(y, eps: Self.originEps) else {

      if let limits = anchorLimits, y > limits.upperBound {
        moveYToTheNearestAnchor(with: -velocity.y, source: .scrollDragging)
        return

      } else {
        sendDidEndUpdatingY(with: .scrollDragging)
        return
      }
    }

    // Stop scrolling
    if let scrollingContent {
      targetContentOffset?.pointee = scrollingContent.contentOffset
    }

    moveYToTheNearestAnchor(with: -velocity.y, source: .scrollDragging)
  }
}

// MARK: Anchors

extension UIBottomSheet {
  public enum YChangeSource {
    case panGestureInteraction
    case scrollDragging
    case program
  }

  private static let originEps: CGFloat = 1 / UIScreen.main.scale

  private func moveYToTheNearestAnchor(
    with velocity: CGFloat,
    source: YChangeSource,
    completion: ((Bool) -> Void)? = nil
  ) {
    let decelerationRate = UIScrollView.DecelerationRate.fast.rawValue
    let projection = y.project(initialVelocity: velocity, decelerationRate: decelerationRate)

    guard let projectionAnchor = anchors.nearestElement(to: projection) else { return }

    let yAnchor: CGFloat

    if (projectionAnchor - y) * velocity < 0 { // if velocity is too low to change the current anchor
      // select the next anchor anyway
      yAnchor = selectNextAnchor(to: projectionAnchor, velocity: velocity)
    } else {
      yAnchor = projectionAnchor
    }

    if !y.isEqual(to: yAnchor, eps: Self.originEps) {
      move(to: yAnchor, source: source, animated: true, velocity: velocity)
    }
  }

  private func selectNextAnchor(to anchor: CGFloat, velocity: CGFloat) -> CGFloat {
    if velocity == 0 || anchors.isEmpty {
      return anchor
    }

    let sortedAnchors = anchors.sorted()

    if let anchorIndex = sortedAnchors.firstIndex(of: anchor) {
      let nextIndex = velocity > 0 ? anchorIndex + 1 : anchorIndex - 1
      let clampedIndex = nextIndex.clamped(to: 0 ... anchors.count - 1)
      return sortedAnchors[clampedIndex]
    }

    return anchor
  }
}

// MARK: Content height

extension UIBottomSheet {
  @discardableResult
  internal func updateViewTopAnchor() -> CGFloat {
    let topConstraint: CGFloat

    if y < safeAreaInsets.top, !viewIgnoresTopSafeArea {
      topConstraint = max(safeAreaInsets.top - y, 0)
    } else {
      topConstraint = 0
    }

    if topConstraint != viewTopConstraint?.constant {
      viewTopConstraint?.constant = topConstraint
    }

    return topConstraint
  }

  @discardableResult
  internal func updateViewHeight() -> CGFloat {
    guard let minY = anchors.min() else { return 0 }

    var viewHeight: CGFloat
    if viewIgnoresTopSafeArea {

      var bottomOffset: CGFloat

      if viewIgnoresBottomSafeArea {
        bottomOffset = 0
      } else {
        bottomOffset = safeAreaInsets.bottom
      }

      if !viewIgnoresBottomBarHeight {
        bottomOffset += bottomBarHeight
      }

      viewHeight = bounds.height - minY - bottomOffset

      if y < minY {
        viewHeight += minY - y
      }

    } else {
      viewHeight = bounds.height - max(minY, safeAreaInsets.top) - safeAreaInsets.bottom
    }

    if viewHeight != viewHeightConstraint?.constant {
      viewHeightConstraint?.constant = viewHeight
    }

    return viewHeight
  }

  @discardableResult
  internal func updateBottomBarAreaHeight() -> CGFloat {
    let bottomBarConnectedY: CGFloat

    if let bottomBarConnectedPosition = detents.bottomBarConnectedPosition {
      bottomBarConnectedY = detents.y(for: bottomBarConnectedPosition)
    } else {

      guard !anchors.isEmpty, let max = anchors.max() else {
        bottomBarAreaHeightConstraint?.constant = 0
        return 0
      }
      bottomBarConnectedY = max
    }

    let safeAreaBottomInset = safeAreaInsets.bottom
    let bottomBarHeight = bottomBarHeight

    guard y > bottomBarConnectedY else {
      bottomBarAreaHeightConstraint?.constant = safeAreaBottomInset + bottomBarHeight
      return safeAreaBottomInset + bottomBarHeight
    }

    let diff = y - bottomBarConnectedY
    let _barAreaHeight: CGFloat = safeAreaBottomInset + bottomBarHeight - diff
    let barAreaHeight = max(_barAreaHeight, 0)

    bottomBarAreaHeightConstraint?.constant = barAreaHeight
    return barAreaHeight
  }
}

// MARK: Moving

extension UIBottomSheet {
  private func updateY(_ newY: CGFloat, source: YChangeSource) {
    y = newY
    updateViewTopAnchor()
    updateViewHeight()
    updateBottomBarAreaHeight()
    sendDidUpdateY(with: source)
  }

  private func move(
    to newY: CGFloat,
    source: YChangeSource,
    animated: Bool,
    velocity: CGFloat? = nil,
    completion: ((Bool) -> Void)? = nil
  ) {
    guard animated else {
      updateY(newY, source: source)
      sendDidEndUpdatingY(with: source)
      completion?(true)
      return
    }

    let yAnimation = UIBottomSheetDefaultSpringAnimation(
      initialOrigin: y,
      targetOrigin: newY,
      initialVelocity: velocity ?? 0,
      parameters: animationParameters,
      onUpdate: { [weak self] value in
        self?.updateY(value, source: source)
      },
      completion: { [weak self] finished in
        guard self != nil else { return }
        self?.sendDidEndUpdatingY(with: source)
        completion?(finished)
      }
    )

    self.yAnimation = yAnimation
    sendWillBeginAnimation(willBeginAnimation: yAnimation, source: source)
  }

  private func stopYAnimation() {
    yAnimation?.invalidate()
    yAnimation = nil
  }
}

// MARK: Sending to subscribers

extension UIBottomSheet {
  private func sendWillBeginUpdatingY(with source: YChangeSource) {
    subscribers.forEach {
      $0.bottomSheet(self, willBeginUpdatingY: y, source: source)
    }
  }

  private func sendDidUpdateY(with source: YChangeSource) {
    subscribers.forEach {
      $0.bottomSheet(self, didUpdateY: y, source: source)
    }
  }

  private func sendDidEndUpdatingY(with source: YChangeSource) {
    subscribers.forEach {
      $0.bottomSheet(self, didEndUpdatingY: y, source: source)
    }
  }

  private func sendWillBeginAnimation(
    willBeginAnimation animation: UIBottomSheetAnimation,
    source: YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(self, willBeginAnimation: animation, source: source)
    }
  }
}

// MARK: AnchorableBottomSheetDelegate default

public extension UIBottomSheetSubscriber {
  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didUpdateY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    didEndUpdatingY y: CGFloat,
    source: UIBottomSheet.YChangeSource
  ) {}

  func bottomSheet(
    _ bottomSheet: UIBottomSheet,
    willBeginAnimation animation: UIBottomSheetAnimation,
    source: UIBottomSheet.YChangeSource
  ) {}
}
