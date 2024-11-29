//
//  TestContentViewController.swift
//  ExampleApp
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import UIKit

protocol TestContentViewControllerDelegate: AnyObject {
  func scrollViewWillBeginDragging(
    _ scrollView: UIScrollView
  )

  func scrollViewDidScroll(
    _ scrollView: UIScrollView
  )

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  )

  /// Just test logic
  func showSecondTableView(_ scrollView: UIScrollView)
  func hideSecondTableView()
}

final class TestContentViewController: UIViewController {

  weak var delegate: TestContentViewControllerDelegate?

  let headerView = UIView()
  let tableView1 = UITableView()
  let tableView2 = SomeTableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

// MARK: Setup UI

extension TestContentViewController {
  func setupUI() {
    view.backgroundColor = .white
    setupHierarchy()
    layout()
    setupHeaderView()
    setupTableView1()
    tableView2.isHidden = true
  }

  private func setupHierarchy() {
    view.addSubview(headerView)
    view.addSubview(tableView1)
    view.addSubview(tableView2)
  }

  private func layout() {
    headerView.constraints([.top, .leading, .trailing])
    headerView.constraint(.height, equalTo: 120)

    tableView1.constraints([.bottom, .leading, .trailing])
    tableView1.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

    tableView2.constraints([.bottom, .leading, .trailing])
    tableView2.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
  }

  private func setupHeaderView() {
    let titleLabel = UILabel()
    titleLabel.text = "Some static UIVIew"

    headerView.addSubview(titleLabel)
    titleLabel.constraint(.centerX)
    titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24).isActive = true

    let items = ["ScrollingContent", "ScrollView"]
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = 0
    headerView.addSubview(segmentedControl)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
    segmentedControl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
    segmentedControl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16).isActive = true
    segmentedControl.heightAnchor.constraint(equalToConstant: 44).isActive = true
    segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
  }

  @objc func segmentChanged(_ sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 0 {
      tableView2.isHidden = true
      delegate?.hideSecondTableView()
    } else {
      tableView2.isHidden = false
      delegate?.showSecondTableView(tableView2)
    }
  }

  func setupTableView1() {
    tableView1.dataSource = self
    tableView1.delegate = self
  }

}

extension TestContentViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 10
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    15
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.textLabel?.text = "Cell for row at \(indexPath)"
    return cell
  }

}

extension TestContentViewController: UITableViewDelegate {
  func scrollViewWillBeginDragging(
    _ scrollView: UIScrollView
  ) {
    delegate?.scrollViewWillBeginDragging(scrollView)
  }

  func scrollViewDidScroll(
    _ scrollView: UIScrollView
  ) {
    delegate?.scrollViewDidScroll(scrollView)
  }

  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    delegate?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      // Верните заголовок для каждой секции
      return "Section \(section + 1)"
  }
}

final class SomeTableView: UITableView {

  init() {
    super.init(frame: .zero, style: .insetGrouped)
    delegate = self
    dataSource = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension SomeTableView: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return 15
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    (5...10).randomElement() ?? 15
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.textLabel?.text = "Any Cell with \(indexPath)"
    return cell
  }

}

extension SomeTableView: UITableViewDelegate {
  func scrollViewDidScroll(
    _ scrollView: UIScrollView
  ) {
    // Any private logic
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return "Section \(section + 1)"
  }
}
