//
//  DynamicBottomSheetController.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

open class DynamicBottomSheetController: UIViewController {

  open var bottonSheet = DynamicBottomSheet()

  public init(_ bottonSheet: DynamicBottomSheet = DynamicBottomSheet()) {
    self.bottonSheet = bottonSheet
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .overFullScreen

    bottonSheet.detents.positions = [.top()]
  }

  @available(*, unavailable)
  required public init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  open override func loadView() {
    let view = TouchProviderView(bottomSheet: bottonSheet)
    self.view = view
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(bottonSheet)
    bottonSheet.constraints([.top, .leading, .trailing, .bottom])
  }

  open override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    guard flag else {
      super.dismiss(animated: flag, completion: completion)
      return
    }

    bottonSheet.isUserInteractionEnabled = false
    bottonSheet.detents.move(to: .bottom(ignoresSafeArea: true)) { _ in
      completion?()
    }
  }

}

extension DynamicBottomSheetController {
  open class TouchProviderView: UIView {

    let bottomSheet: DynamicBottomSheet

    init(bottomSheet: DynamicBottomSheet) {
      self.bottomSheet = bottomSheet
      super.init(frame: .zero)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
      bottomSheet.point(inside: point, with: event)
    }

  }

}
