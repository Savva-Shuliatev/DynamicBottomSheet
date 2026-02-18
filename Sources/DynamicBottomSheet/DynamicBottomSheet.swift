//
//  DynamicBottomSheet.swift
//  DynamicBottomSheet
//
//  Modified based on code covered by the MIT License.
//  Original code by Ilya Lobanov, available at https://github.com/super-ultra/UltraDrawerView.
//  Copyright (c) 2019 Ilya Lobanov
//
//  Modifications by Savva Shuliatev, 2024
//  This code is also covered by the MIT License.
//

import UIKit
import Combine

open class DynamicBottomSheet: UIView {

  public let detents: Detents
  public let bottomBar: BottomBar

  public private(set) lazy var visibleView = loadVisibleView()
  public private(set) lazy var view = loadView()
  public private(set) lazy var grabber = loadGrabber()

  public var scrollViewIntegrationMode: ScrollViewIntegrationMode

  public var areAnimationsEnabled: Bool

#if DEBUG
  @MainActor
  public static var slowAnimations = false
#endif

  /// Animation parameters for the transitions between anchors
  open var animationParameters: AnimationParameters

  /// A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
  open var bounces: Bool

  open var bouncesFactor: CGFloat

  open var canBeRefreshed: Bool = false

  open var cornerRadius: CGFloat {
    didSet {
      guard didLayoutSubviews else { return }
      updateCornerRadius()
      updateShadows()
    }
  }

  open var viewIgnoresBottomSafeArea: Bool {
    didSet {
      guard didLayoutSubviews else { return }
      updateViewHeight()
    }
  }

  open var viewIgnoresTopSafeArea: Bool {
    didSet {
      guard didLayoutSubviews else { return }
      updateViewHeight()
    }
  }

  open var prefersGrabberVisible: Bool {
    didSet {
      grabber.isHidden = !prefersGrabberVisible
    }
  }

  open var shadowColor: CGColor? {
    didSet {
      guard didLayoutSubviews else { return }
      updateShadows()
    }
  }

  open var shadowOpacity: Float {
    didSet {
      guard didLayoutSubviews else { return }
      updateShadows()
    }
  }

  open var shadowOffset: CGSize {
    didSet {
      guard didLayoutSubviews else { return }
      updateShadows()
    }
  }

  open var shadowMode: ShadowMode {
    didSet {
      guard didLayoutSubviews else { return }
      updateShadows()
    }
  }

  open var shadowPath: CGPath? {
    didSet {
      guard didLayoutSubviews else { return }
      updateShadows()
    }
  }

  open var shadowRadius: CGFloat {
    didSet {
      guard didLayoutSubviews else { return }
      updateShadows()
    }
  }

  public let onDidUpdateY = PassthroughSubject<DidUpdateYContext, Never>()
  public let onDidEndUpdatingY = PassthroughSubject<DidEndUpdatingYContext, Never>()
  public let onFirstAppear = PassthroughSubject<Void, Never>()
  public let onWillBeginUpdatingY = PassthroughSubject<WillBeginUpdatingYContext, Never>()
  public let onWillBeginAnimation = PassthroughSubject<WillBeginAnimationContext, Never>()
  public let onWillMoveToNewY = PassthroughSubject<WillMoveToContext, Never>()

  public internal(set) var anchors: [CGFloat] = []

  public var anchorLimits: ClosedRange<CGFloat>? {
    if let min = anchors.min(), let max = anchors.max() {
      return min...max
    } else {
      return nil
    }
  }

  public var onAnimation: Bool { yAnimation != nil }

  public private(set) var didLayoutSubviews = false

  public private(set) var lastViewGeometry: ViewGeometry = .zero

  open private(set) var y: CGFloat = 0 {
    didSet {
      visibleViewYConstraint?.constant = y
    }
  }

  private var visibleViewYConstraint: NSLayoutConstraint?
  private var viewTopConstraint: NSLayoutConstraint?
  private var viewHeightConstraint: NSLayoutConstraint?

  internal var bottomBarHeightConstraint: NSLayoutConstraint?
  private var bottomBarAreaHeightConstraint: NSLayoutConstraint?

  private var panRecognizerState: PanRecognizerState = .empty
  private let panRecognizer = UIPanGestureRecognizer()

  private var scrollingContentHolder: ScrollingContentHolder?
  private var scrollingState: ScrollingState = .empty
  private var scrollingListening: Bool = true
  private var scrollingOffsetUnderLastAnchor: CGFloat = 0

  private var yAnimation: DynamicBottomSheetDefaultSpringAnimation?

  private var subscribers = Subscribers<DynamicBottomSheetSubscriber>()

  // MARK: - Init

  public init(configuration: Configuration? = nil) {
    let configuration = configuration ?? DynamicBottomSheet.globalConfiguration
    self.scrollViewIntegrationMode = configuration.scrollViewIntegrationMode
    self.areAnimationsEnabled = configuration.areAnimationsEnabled
    self.animationParameters = configuration.animationParameters
    self.bounces = configuration.bounces
    self.bouncesFactor = configuration.bouncesFactor
    self.cornerRadius = configuration.cornerRadius
    self.viewIgnoresBottomSafeArea = configuration.viewIgnoresBottomSafeArea
    self.viewIgnoresTopSafeArea = configuration.viewIgnoresTopSafeArea
    self.prefersGrabberVisible = configuration.prefersGrabberVisible
    self.shadowColor = configuration.shadowColor
    self.shadowOpacity = configuration.shadowOpacity
    self.shadowOffset = configuration.shadowOffset
    self.shadowMode = configuration.shadowMode
    self.shadowPath = configuration.shadowPath
    self.shadowRadius = configuration.shadowRadius

    self.detents = Detents(configuration: configuration.detentsConfiguration)
    self.bottomBar = BottomBar(configuration: configuration)

    super.init(frame: .zero)

    detents.bottomSheet = self
    bottomBar.bottomSheet = self

    setupUI()
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UIView methods

  open override func layoutSubviews() {
    super.layoutSubviews()

    if !didLayoutSubviews {
      didLayoutSubviews = true

      setInitialLayout()
      detents.updateAnchors()
      updateCornerRadius()

      onFirstAppear.send()
    }

    if lastViewGeometry != ViewGeometry(of: self) {
      lastViewGeometry = ViewGeometry(of: self)

      detents.updateAnchors()
      updateCornerRadius()
      updateViewHeight()
      updateViewTopAnchor()
      updateBottomBarAreaHeight()
    }

    updateShadows()

  }

  override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    let visibleRect = CGRect(
      x: .zero,
      y: y,
      width: bounds.width,
      height: bounds.height - y
    )
    return visibleRect.contains(point)
  }

  // MARK: - Public methods

  open func scroll(
    to newY: CGFloat,
    animated: Bool = true,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger = .all,
    completion: ((Bool) -> Void)? = nil
  ) {
    guard yAnimation?.interruptTriggers.contains(.program) ?? true else {
      completion?(false)
      return
    }
    stopYAnimation()
    sendWillBeginUpdatingY(with: .program)
    move(to: newY, source: .program, animated: animated, interruptTriggers: interruptTriggers, completion: completion)
  }

  open func moveToTheNearestAnchor(
    with velocity: CGFloat = .zero,
    completion: ((Bool) -> Void)? = nil
  ) {
    stopYAnimation()
    sendWillBeginUpdatingY(with: .program)
    moveYToTheNearestAnchor(with: velocity, source: .program, completion: completion)
  }

  open func getTheNearestAnchor(with velocity: CGFloat = .zero) -> CGFloat? {
    calculateTheNearestAnchor(with: velocity)
  }

  open func subscribe(_ subscriber: DynamicBottomSheetSubscriber) {
    subscribers.subscribe(subscriber)
  }

  open func unsubscribe(_ subscriber: DynamicBottomSheetSubscriber) {
    subscribers.unsubscribe(subscriber)
  }

  open func loadVisibleView() -> UIView {
    return UIView()
  }

  open func loadView() -> UIView {
    return UIView()
  }

  open func loadGrabber() -> UIView {
    let grabber = UIView()
    grabber.backgroundColor = .tertiaryLabel
    grabber.layer.cornerRadius = 2.5
    return grabber
  }

}

// MARK: Setup UI

extension DynamicBottomSheet {
  private func setupUI() {
    visibleView.backgroundColor = .systemBackground
    view.backgroundColor = .systemBackground
    bottomBar.area.backgroundColor = .systemBackground
    bottomBar.view.backgroundColor = .systemBackground
    bottomBar.area.isHidden = bottomBar.isHidden
    bottomBar.view.isHidden = bottomBar.isHidden

    addSubview(visibleView)
    visibleView.addSubview(view)
    visibleView.addSubview(grabber)
    addSubview(bottomBar.area)
    bottomBar.area.addSubview(bottomBar.view)

    view.constraints([.leading, .trailing])

    grabber.constraint(.top, constant: 5)
    grabber.constraint(.centerX)
    grabber.constraint(.height, equalTo: 5)
    grabber.constraint(.width, equalTo: 36)
    grabber.isHidden = !prefersGrabberVisible

    visibleView.addGestureRecognizer(panRecognizer)
    panRecognizer.addTarget(self, action: #selector(handlePanRecognizer))
    panRecognizer.delegate = self
  }

  private func setInitialLayout() {
    let initialY = detents.y(for: detents.initialPosition)
    visibleViewYConstraint = visibleView.constraint(.top, constant: initialY)
    updateY(initialY, source: .program)
    viewTopConstraint = view.constraint(.top, constant: 0)
    viewHeightConstraint = view.constraint(.height, equalTo: updateViewHeight())
    visibleView.constraints([.leading, .trailing, .bottom])

    bottomBar.area.constraints([.leading, .trailing, .bottom])
    bottomBarAreaHeightConstraint = bottomBar.area.constraint(.height, equalTo: updateBottomBarAreaHeight())

    bottomBar.view.constraints([.leading, .trailing, .top])
    bottomBarHeightConstraint = bottomBar.view.constraint(.height, equalTo: bottomBar.height)
  }

  private func updateCornerRadius() {
    let cornerRadius = max(0, cornerRadius)

    guard
      didLayoutSubviews,
      visibleView.layer.cornerRadius != cornerRadius
    else { return }

    visibleView.layer.cornerRadius = cornerRadius
    visibleView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    visibleView.layer.masksToBounds = true
  }

  private func updateShadows() {
    guard didLayoutSubviews else { return }

    if layer.shadowColor != shadowColor {
      self.layer.shadowColor = shadowColor
    }

    if layer.shadowOpacity != shadowOpacity {
      layer.shadowOpacity = shadowOpacity
    }

    if layer.shadowOffset != shadowOffset {
      layer.shadowOffset = shadowOffset
    }

    if layer.shadowRadius != shadowRadius {
      layer.shadowRadius = shadowRadius
    }

    if shadowPath != nil {
      if layer.shadowPath != shadowPath {
        layer.shadowPath = shadowPath
      }
    } else {
      switch shadowMode {
      case .automatic:
        if layer.shadowPath != nil {
          layer.shadowPath = nil
        }

      case .optimized:
        let targetRect = CGRect(
          x: 0,
          y: y,
          width: bounds.width,
          height: max(0, bounds.height - y)
        )

        let path = UIBezierPath(
          roundedRect: targetRect,
          cornerRadius: cornerRadius
        ).cgPath

        if layer.shadowPath != path {
          layer.shadowPath = path
        }
      }
    }

  }
}

// MARK: Pan Recognizer

extension DynamicBottomSheet {

  private enum PanRecognizerState: Equatable {
    case empty
    case dragging(initialY: CGFloat, onView: Weak<UIView>)
  }

  @objc
  public func handlePanRecognizer(_ sender: UIPanGestureRecognizer) {
    guard yAnimation?.interruptTriggers.contains(.panGesture) ?? true else {
      panRecognizerState = .empty
      return
    }

    switch sender.state {
    case .began:
      stopYAnimation()
      panRecognizerState = .dragging(initialY: y, onView: Weak(sender.view))
      sendWillBeginUpdatingY(with: .panGestureInteraction)

    case .changed:
      guard
        case let .dragging(initialY, onView) = panRecognizerState,
        onView.object === sender.view
      else { return }

      let translation = sender.translation(in: visibleView)
      let newY = clampY(initialY + translation.y)
      updateY(newY, source: .panGestureInteraction)

    case .ended:
      guard
        case let .dragging(_, onView) = panRecognizerState,
        onView.object === sender.view
      else { return }
      
      panRecognizerState = .empty
      let velocity = sender.velocity(in: visibleView).y / 1000
      moveYToTheNearestAnchor(with: velocity, source: .panGestureInteraction)

    case .cancelled, .failed:
      guard case .dragging = panRecognizerState else { return }
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

extension DynamicBottomSheet {

  public func connect(_ scrollView: UIScrollView) {
    if let currentScrollingContentHolder = scrollingContentHolder {
      switch currentScrollingContentHolder {
      case .scrollViewHolder(let scrollViewHolder):
        if scrollViewHolder.scrollView === scrollView {
          return
        }
      case .scrollingContent(let weakscrollingContentBox):
        break
      }
    }

    let scrollViewHolder = UIScrollViewHolder(
      scrollView: scrollView,
      bottomSheet: self
    )
    scrollingListening = true
    scrollingState = .empty
    scrollingContentHolder = .scrollViewHolder(scrollViewHolder)
  }

  public func connect(_ scrollingContent: ScrollingContent) {
    scrollingListening = true
    scrollingState = .empty
    scrollingContentHolder = .scrollingContent(.weak(scrollingContent))
  }

  public func disconnectScroll() {
    scrollingListening = true
    scrollingState = .empty
    scrollingContentHolder = nil
    scrollingOffsetUnderLastAnchor = .zero
  }

  public func didConnected() -> Bool {
    scrollingContentHolder != nil
  }

  @MainActor
  public protocol ScrollingContent: AnyObject {
    var contentOffset: CGPoint { get set }
    func stopScrolling()
  }

  private enum ScrollingState: Equatable {
    case empty
    case dragging(lastContentOffset: CGPoint)
  }

  public func scrollViewWillBeginDragging(with contentOffset: CGPoint) {
    guard scrollingListening, yAnimation?.interruptTriggers.contains(.scrollDragging) ?? true else {
      scrollingState = .empty
      return
    }

    scrollingState = .dragging(lastContentOffset: contentOffset)
    stopYAnimation()
    sendWillBeginUpdatingY(with: .scrollDragging)
  }

  public func scrollViewDidScroll(contentOffset: CGPoint, contentInset: UIEdgeInsets) {
    guard
      scrollingListening,
      yAnimation?.interruptTriggers.contains(.scrollDragging) ?? true,
      case let .dragging(lastContentOffset) = scrollingState
    else {

      if scrollingListening {
        if let upperBound = anchorLimits?.upperBound,
            y.isEqual(to: upperBound, eps: Self.originEps),
            contentOffset.y < -contentInset.top,
           canBeRefreshed {
          return
        }

        if contentOffset.y < -contentInset.top {
          scrollingContentHolder?.scrollingContent?.stopScrolling()
        }
      }

      return
    }

    guard let limits = anchorLimits else { return }

    let diff = lastContentOffset.y - contentOffset.y

    if (
      diff < 0 &&
      contentOffset.y > -contentInset.top &&
      y.isGreater(than: limits.lowerBound, eps: Self.originEps) &&
      scrollingOffsetUnderLastAnchor <= 0 + Self.originEps
    ) || (
      diff > 0 && contentOffset.y < -contentInset.top &&
      y.isLess(than: limits.upperBound, eps: Self.originEps) &&
      scrollingOffsetUnderLastAnchor <= 0 + Self.originEps
    ) {
      // Drop contentOffset changing
      scrollingListening = false
      if diff > 0 {
        scrollingContentHolder?.scrollingContent?.contentOffset.y = -contentInset.top
      } else {
        scrollingContentHolder?.scrollingContent?.contentOffset.y += diff
      }
      scrollingListening = true


      let newY = (y + diff).clamped(to: limits)

      updateY(newY, source: .scrollDragging)

      if let scrollingContent = scrollingContentHolder?.scrollingContent {
        scrollingState = .dragging(lastContentOffset: scrollingContent.contentOffset)
      }

    } else if ((
      diff > 0 &&
      y >= limits.upperBound - Self.originEps &&
      lastContentOffset.y <= 0
    ) || (
      diff < 0 &&
      y >= limits.upperBound - Self.originEps &&
      lastContentOffset.y >= 0
    )) && !canBeRefreshed, case let .dragging(lastContentOffset) = scrollingState, lastContentOffset == .init(x: 0, y: -contentInset.top) {

      scrollingListening = false
      scrollingContentHolder?.scrollingContent?.contentOffset.y = -contentInset.top
      scrollingState = .dragging(lastContentOffset: .init(x: 0, y: -contentInset.top))
      scrollingListening = true

      let newY = clampY(y + scrollingOffsetUnderLastAnchor + diff)
      scrollingOffsetUnderLastAnchor += diff
      updateY(newY, source: .scrollDragging)

    } else {
      if let scrollingContent = scrollingContentHolder?.scrollingContent {
        scrollingState = .dragging(lastContentOffset: scrollingContent.contentOffset)
      }
    }
  }

  public func scrollViewWillEndDragging(
    withVelocity velocity: CGPoint,
    yContentOffset: CGFloat,
    topContentInset: CGFloat,
    targetContentOffset: UnsafeMutablePointer<CGPoint>?
  ) {
    guard scrollingListening, yAnimation?.interruptTriggers.contains(.scrollDragging) ?? true else { return }
    scrollingState = .empty
    scrollingOffsetUnderLastAnchor = 0

    if velocity.y == 0 {
      moveYToTheNearestAnchor(with: -velocity.y, source: .scrollDragging)

    } else if velocity.y > 0 {
      if let lowerAnchor = anchors.min() {
        if y.isGreater(than: lowerAnchor, eps: Self.originEps) {
          if let scrollingContent = scrollingContentHolder?.scrollingContent {
            targetContentOffset?.pointee = scrollingContent.contentOffset
          }
          moveYToTheNearestAnchor(with: -velocity.y, source: .scrollDragging)
        }
      }

    } else {
      if yContentOffset > -topContentInset {
        moveYToTheNearestAnchor(with: .zero, source: .scrollDragging)
      } else {
        moveYToTheNearestAnchor(with: -velocity.y, source: .scrollDragging)
      }
    }
  }
}

// MARK: Anchors

extension DynamicBottomSheet {
  public enum YChangeSource: Sendable {
    case panGestureInteraction
    case scrollDragging
    case program
  }

  @MainActor
  private static let originEps: CGFloat = 1 / UIScreen.main.scale

  private func moveYToTheNearestAnchor(
    with velocity: CGFloat,
    source: YChangeSource,
    completion: ((Bool) -> Void)? = nil
  ) {
    guard let yAnchor = calculateTheNearestAnchor(with: velocity) else {
      completion?(false)
      return
    }

    if !y.isEqual(to: yAnchor, eps: Self.originEps) {
      move(to: yAnchor, source: source, animated: true, velocity: velocity, completion: completion)
    }
  }

  private func calculateTheNearestAnchor(with velocity: CGFloat) -> CGFloat? {
    let decelerationRate = UIScrollView.DecelerationRate.fast.rawValue
    let projection = y.project(initialVelocity: velocity, decelerationRate: decelerationRate)

    guard let projectionAnchor = anchors.nearestElement(to: projection) else { return nil }

    let yAnchor: CGFloat

    if (projectionAnchor - y) * velocity < 0 { // if velocity is too low to change the current anchor
      // select the next anchor anyway
      yAnchor = selectNextAnchor(to: projectionAnchor, velocity: velocity)
    } else {
      yAnchor = projectionAnchor
    }

    return yAnchor
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

extension DynamicBottomSheet {
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

      if !bottomBar.isHidden, !bottomBar.viewIgnoresBottomBarHeight {
        bottomOffset += bottomBar.height
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

    if let bottomBarConnectedPosition = bottomBar.connectedPosition {
      bottomBarConnectedY = detents.y(for: bottomBarConnectedPosition)
    } else {

      guard !anchors.isEmpty, let max = anchors.max() else {
        bottomBarAreaHeightConstraint?.constant = 0
        return 0
      }
      bottomBarConnectedY = max
    }

    let safeAreaBottomInset = safeAreaInsets.bottom
    let bottomBarHeight = bottomBar.height

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

extension DynamicBottomSheet {
  private func updateY(_ newY: CGFloat, source: YChangeSource) {
    y = min(bounds.height, newY)
    updateViewTopAnchor()
    updateViewHeight()
    updateBottomBarAreaHeight()
    sendDidUpdateY(with: source)
  }

  private func move(
    to newY: CGFloat,
    source: YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger = .all,
    velocity: CGFloat? = nil,
    completion: ((Bool) -> Void)? = nil
  ) {
    let testableAnimated = areAnimationsEnabled && UIView.areAnimationsEnabled && animated

    sendwillMoveToY(
      to: newY,
      source: source,
      animated: animated,
      interruptTriggers: interruptTriggers,
      velocity: velocity
    )
    stopYAnimation()

    guard testableAnimated else {
      updateY(newY, source: source)
      sendDidEndUpdatingY(with: source)
      completion?(true)
      return
    }

    panRecognizerState = .empty
    scrollingState = .empty

    let yAnimation = DynamicBottomSheetDefaultSpringAnimation(
      initialOrigin: y,
      targetOrigin: newY,
      initialVelocity: velocity ?? 0,
      interruptTriggers: interruptTriggers,
      parameters: animationParameters,
      onUpdate: { [weak self] value in
        self?.updateY(value, source: source)
      },
      completion: { [weak self] finished in
        guard let self else { return }
        self.stopYAnimation()
        self.sendDidEndUpdatingY(with: source)
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

extension DynamicBottomSheet {
  private func sendWillBeginUpdatingY(with source: YChangeSource) {
    subscribers.forEach {
      $0.bottomSheet(self, willBeginUpdatingY: y, source: source)
    }

    onWillBeginUpdatingY.send(WillBeginUpdatingYContext(y: y, source: source))
  }

  private func sendDidUpdateY(with source: YChangeSource) {
    subscribers.forEach {
      $0.bottomSheet(self, didUpdateY: y, source: source)
    }

    onDidUpdateY.send(DidUpdateYContext(y: y, source: source))
  }

  private func sendDidEndUpdatingY(with source: YChangeSource) {
    subscribers.forEach {
      $0.bottomSheet(self, didEndUpdatingY: y, source: source)
    }

    onDidEndUpdatingY.send(DidEndUpdatingYContext(y: y, source: source))
  }

  private func sendWillBeginAnimation(
    willBeginAnimation animation: DynamicBottomSheetAnimation,
    source: YChangeSource
  ) {
    subscribers.forEach {
      $0.bottomSheet(self, willBeginAnimation: animation, source: source)
    }

    onWillBeginAnimation.send(WillBeginAnimationContext(animation: animation, source: source))
  }

  private func sendwillMoveToY(
    to newY: CGFloat,
    source: YChangeSource,
    animated: Bool,
    interruptTriggers: DynamicBottomSheet.InterruptTrigger,
    velocity: CGFloat?
  ) {
    subscribers.forEach {
      $0.bottomSheet(
        self,
        willMoveTo: newY,
        source: source,
        animated: animated,
        interruptTriggers: interruptTriggers,
        velocity: velocity
      )
    }

    onWillMoveToNewY.send(
      WillMoveToContext(
        newY: newY,
        source: source,
        animated: animated,
        interruptTriggers: interruptTriggers,
        velocity: velocity
      )
    )
  }

}

// MARK: UIGestureRecognizerDelegate

extension DynamicBottomSheet: UIGestureRecognizerDelegate {

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldReceive touch: UITouch
  ) -> Bool {
    guard let touchedView = touch.view else { return false }

    if let scrollView = findVerticalScrollView(from: touchedView, inside: self) {
      switch scrollViewIntegrationMode {
      case .auto:
        connect(scrollView)

      case .manual:
        break
      }
    }

    return true
  }

}

// MARK: Find ScrollView

extension DynamicBottomSheet {
  private func findVerticalScrollView(
    from touchView: UIView?,
    inside rootView: UIView
  ) -> UIScrollView? {
    var current = touchView
    var fallbackScrollView: UIScrollView?

    while let view = current {
      if view == rootView { break }

      if let scrollView = view as? UIScrollView {

        // 1. Ignore Wrappers
        if scrollView.superview is UITableView {
          current = view.superview
          continue
        }

        let isHorizontal = scrollView.contentSize.width > scrollView.frame.width + 1
        let isVertical = scrollView.isScrollEnabled && (scrollView.contentSize.height > scrollView.frame.height + 1 || scrollView.alwaysBounceVertical)

        if isVertical {
          return scrollView
        } else if isHorizontal {
          if fallbackScrollView == nil { fallbackScrollView = scrollView }
        } else {
          if fallbackScrollView == nil || (fallbackScrollView?.contentSize.width ?? 0) > (fallbackScrollView?.frame.width ?? 0) {
            fallbackScrollView = scrollView
          }
        }
      }

      current = view.superview
    }

    return fallbackScrollView
  }
}
