//
//  NativeBottomSheetViewController.swift
//  ExampleApp
//
//  Created by Savva Shuliatev on 10.10.2025.
//

import UIKit

/// Контроллер с нативным модальным bottom sheet с тремя состояниями
final class NativeBottomSheetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        let showSheetButton = UIButton(type: .system)
        showSheetButton.setTitle("Показать Native Bottom Sheet", for: .normal)
        showSheetButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        showSheetButton.backgroundColor = .white
        showSheetButton.setTitleColor(.systemBlue, for: .normal)
        showSheetButton.layer.cornerRadius = 12
        showSheetButton.translatesAutoresizingMaskIntoConstraints = false
        showSheetButton.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
        
        view.addSubview(showSheetButton)
        
        NSLayoutConstraint.activate([
            showSheetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showSheetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showSheetButton.widthAnchor.constraint(equalToConstant: 280),
            showSheetButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        setupCloseButton()
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeScreen), for: .touchUpInside)
        
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func closeScreen() {
        dismiss(animated: true)
    }
    
    @objc private func showBottomSheet() {
        let bottomSheetVC = BottomSheetContentViewController()

      //UISheetPresentationController
        if let sheet = bottomSheetVC.sheetPresentationController {

          
            // Создаем три состояния: нижнее (200pt), среднее (50%), верхнее (большое)
            sheet.detents = [
                .custom(identifier: .small) { context in
                    return 56 // Нижнее состояние - 200 точек
                },
              .medium(), // Среднее состояние - 50% экрана
                .large()   // Верхнее состояние - почти весь экран
            ]



            // Начинаем со среднего состояния
            sheet.selectedDetentIdentifier = .medium
            
            // Показываем индикатор (grabber)
            sheet.prefersGrabberVisible = true

          sheet.prefersEdgeAttachedInCompactHeight = true

            // Разрешаем пользователю перетаскивать sheet
            //sheet.prefersScrollingExpandsWhenScrolledToEdge = false

            // Скругляем углы
            //sheet.preferredCornerRadius = 20

            // Позволяем изменять размер
            //sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(bottomSheetVC, animated: true)
    }
}

/// Контроллер с контентом для bottom sheet
final class BottomSheetContentViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    print("frame = \(view.frame)")
    print("")
    print("bounds = \(view.bounds)")
    print("")
  }

    private func setupUI() {
        // Настройка scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Настройка stack view
        contentStackView.axis = .vertical
        contentStackView.spacing = 16
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
        
        // Добавляем контент
        addTitle()
        addDescription()
        addStateInfo()
        addButtons()
        addSampleContent()
    }
    
    private func addTitle() {
        let titleLabel = UILabel()
        titleLabel.text = "Native Bottom Sheet"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textAlignment = .center
        contentStackView.addArrangedSubview(titleLabel)
    }
    
    private func addDescription() {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Это нативный UIKit bottom sheet с тремя состояниями. Потяните за индикатор сверху, чтобы изменить размер."
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        contentStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func addStateInfo() {
        let stateView = UIView()
        stateView.backgroundColor = .systemGray6
        stateView.layer.cornerRadius = 12
        stateView.translatesAutoresizingMaskIntoConstraints = false
        
        let stateStack = UIStackView()
        stateStack.axis = .vertical
        stateStack.spacing = 8
        stateStack.translatesAutoresizingMaskIntoConstraints = false
        stateView.addSubview(stateStack)
        
        NSLayoutConstraint.activate([
            stateStack.topAnchor.constraint(equalTo: stateView.topAnchor, constant: 16),
            stateStack.leadingAnchor.constraint(equalTo: stateView.leadingAnchor, constant: 16),
            stateStack.trailingAnchor.constraint(equalTo: stateView.trailingAnchor, constant: -16),
            stateStack.bottomAnchor.constraint(equalTo: stateView.bottomAnchor, constant: -16)
        ])
        
        let states = [
            "🔻 Нижнее состояние: 200pt",
            "🔸 Среднее состояние: 50%",
            "🔺 Верхнее состояние: Large"
        ]
        
        for state in states {
            let label = UILabel()
            label.text = state
            label.font = .systemFont(ofSize: 15)
            stateStack.addArrangedSubview(label)
        }
        
        contentStackView.addArrangedSubview(stateView)
    }
    
    private func addButtons() {
        let buttonStack = UIStackView()
        buttonStack.axis = .vertical
        buttonStack.spacing = 12
        
        let states: [(title: String, identifier: UISheetPresentationController.Detent.Identifier)] = [
            ("Перейти в нижнее состояние", .small),
            ("Перейти в среднее состояние", .medium),
            ("Перейти в верхнее состояние", .large)
        ]
        
        for (title, identifier) in states {
            let button = createButton(title: title, identifier: identifier)
            buttonStack.addArrangedSubview(button)
        }
        
        contentStackView.addArrangedSubview(buttonStack)
    }
    
    private func createButton(title: String, identifier: UISheetPresentationController.Detent.Identifier) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.addAction(UIAction { [weak self] _ in
            self?.animateToDetent(identifier)
        }, for: .touchUpInside)
        
        return button
    }
    
    private func animateToDetent(_ identifier: UISheetPresentationController.Detent.Identifier) {
        if let sheet = sheetPresentationController {
            sheet.animateChanges {
                sheet.selectedDetentIdentifier = identifier
            }
        }
    }
    
    private func addSampleContent() {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        contentStackView.addArrangedSubview(separator)
        
        let sampleLabel = UILabel()
        sampleLabel.text = "Дополнительный контент"
        sampleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        contentStackView.addArrangedSubview(sampleLabel)
        
        for i in 1...10 {
            let itemLabel = UILabel()
            itemLabel.text = "Элемент списка \(i)"
            itemLabel.font = .systemFont(ofSize: 16)
            itemLabel.textColor = .secondaryLabel
            contentStackView.addArrangedSubview(itemLabel)
        }
    }
}

// Расширение для кастомного идентификатора маленького состояния
extension UISheetPresentationController.Detent.Identifier {
    static let small = UISheetPresentationController.Detent.Identifier("small")
}


