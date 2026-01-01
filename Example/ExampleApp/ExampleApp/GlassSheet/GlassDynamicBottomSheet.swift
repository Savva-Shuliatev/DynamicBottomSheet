//
//  GlassDynamicBottomSheet.swift
//  ExampleApp
//
//  Created by Savva Shuliatev on 09.10.2025.
//

import UIKit
import DynamicBottomSheet

final class MapViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .blue

    let glassBottomSheet = GlassDynamicBottomSheet()
    view.addSubview(glassBottomSheet)
    glassBottomSheet.frame = view.bounds

    glassBottomSheet.detents.positions = [.top(), .middle(), .fromBottom(200)]
    glassBottomSheet.detents.initialPosition = .middle()
  }

}
final class GlassDynamicBottomSheet: DynamicBottomSheet {

    // Предполагаю, что visibleView — это содержимое шита
    // и у тебя есть текущее значение y (констрейнт к верху экрана).
    // Если y — это constraint.constant, сделай геттер под него.

    private let maskLayer = CAShapeLayer()
    private var yMinObserved: CGFloat = .infinity
    private var yMaxObserved: CGFloat = 0

    var finalInset: CGFloat = 24 // целевые отступы слева/справа/снизу в нижнем положении

    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupMaskIfNeeded()
    }

  init() {
    super.init()
    shadowMode = .automatic
  }

    private func setupMaskIfNeeded() {
        guard visibleView.layer.mask == nil else { return }
        maskLayer.fillColor = UIColor.black.cgColor   // для маски важна альфа, не цвет
        maskLayer.contentsScale = UIScreen.main.scale
        visibleView.layer.mask = maskLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupMaskIfNeeded()

        let currentY = y

        // Обновляем наблюдаемые границы хода (верх/низ)
        if currentY < yMinObserved { yMinObserved = currentY }
        if currentY > yMaxObserved { yMaxObserved = currentY }

        // Середина хода: после неё начинаем сжатие
        let midY: CGFloat
        if yMinObserved.isFinite, yMaxObserved > yMinObserved {
            midY = (yMinObserved + yMaxObserved) * 0.5
        } else {
            midY = currentY // пока нет диапазона — считаем, что мы “вверх”
        }

        // Прогресс сжатия только после середины [0, 1]
        let denom = max(1, yMaxObserved - midY)
        var t = (currentY - midY) / denom
        t = max(0, min(1, t))
        // Можно смягчить движение:
        // t = t * t * (3 - 2 * t) // smoothstep

        // Целевые инкрементные отступы
        let hInset = finalInset * t
        let bInset = finalInset * t

        let bounds = visibleView.bounds
        let insetRect = bounds.inset(by: UIEdgeInsets(top: 0, left: hInset, bottom: bInset, right: hInset))

        // Обновляем маску без неявных анимаций
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        maskLayer.frame = bounds
        let path = UIBezierPath(roundedRect: insetRect,
                                byRoundingCorners: .allCorners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        maskLayer.path = path.cgPath

        CATransaction.commit()

        // Debug:
        // print("y:", currentY, "mid:", midY, "t:", t, "insets L/R/B:", hInset, bInset)
    }
}
