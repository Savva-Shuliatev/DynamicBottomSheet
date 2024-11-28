//
//  TestContentViewController.swift
//  ExampleApp
//
//  Created by Savva Shuliatev on 28.11.2024.
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
}

final class TestContentViewController: UIViewController {

  weak var delegate: TestContentViewControllerDelegate?

  let headerView = UIView()
  let tableView = UITableView()

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

}

// MARK: Setup UI

extension TestContentViewController {
  func setupUI() {
    view.backgroundColor = .white
    setupHeaderView()
    setupTableView()
  }


  private func setupHeaderView() {
    view.addSubview(headerView)
    headerView.constraints([.top, .leading, .trailing])
    headerView.constraint(.height, equalTo: 84)

    let titleLabel = UILabel()
    titleLabel.text = "Some static UIVIew"

    headerView.addSubview(titleLabel)
    titleLabel.constraints([.centerX, .centerY])
  }

  func setupTableView() {
    view.addSubview(tableView)
    tableView.constraints([.bottom, .leading, .trailing])
    tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    tableView.dataSource = self
    tableView.delegate = self
  }

}

extension TestContentViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    100
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
}
