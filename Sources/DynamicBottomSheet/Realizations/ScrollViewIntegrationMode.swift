//
//  ScrollViewIntegrationMode.swift
//  DynamicBottomSheet
//
//  Copyright (c) 2024 Savva Shuliatev
//  This code is covered by the MIT License.
//

import Foundation

/// Defines how the `UIScrollView` (or its subclasses such as `UITableView`, `UICollectionView`)
/// should be integrated.
///
/// - In `.auto` mode, the BottomSheet automatically attempts to locate and connect
///   the appropriate `UIScrollView` (for example, a scroll view inside the content
///   or the one currently touched by the user) using internal search and filtering logic.
///   - This simplifies integration in most standard layouts.
///   - However, it may occasionally produce ambiguous results in complex view hierarchies.
///
/// - In `.manual` mode, the developer explicitly provides the target `UIScrollView`.
///   You must manually call a connection method, for example:
///   ```swift
///   bottomSheet.connect(scrollView: tableView)
///   ```
///   This mode offers maximum control and predictability when integrating
///   BottomSheet with complex or nested scroll views.
public enum ScrollViewIntegrationMode: Equatable, Sendable {
  /// The BottomSheet automatically detects and connects a relevant
  /// `UIScrollView` to synchronize sheet movement with scrolling behavior.
  case auto

  /// The developer manually provides the `UIScrollView` instance to connect
  /// by explicitly calling the integration method such as `connect(scrollView:)`.
  case manual
}
