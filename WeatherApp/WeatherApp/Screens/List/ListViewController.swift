//
//  ListViewController.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/12/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UITableViewDataSourcePrefetching {

   let viewModel = ListViewModel()

   override func viewDidLoad() {
      super.viewDidLoad()

      setupUI()
      setupHandlers()

      loadData()
   }

   func loadData() {
      viewModel.startLoading { [weak self] in
         self?.handleError($0)

         if $0 == nil, self?.refreshControl == nil {
            self?.addRefreshControl()
         }
         if self?.refreshControl?.isRefreshing == true {
            self?.refreshControl?.endRefreshing()
         }
      }
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.items.count
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      switch viewModel.items[indexPath.row] {
      case .loading(let viewModel):
         let cell = tableView.dequeueCell(for: indexPath, type: LoadingTableViewCell.self)
         cell.viewModel = viewModel
         cell.retryHandler = { [weak self] in self?.loadData() }
         return cell

      case .weather(let viewModel):
         let cell = tableView.dequeueCell(for: indexPath, type: WeatherTableViewCell.self)
         cell.viewModel = viewModel
         viewModel.imageViewModel.startLoading()
         return cell

      case .myLocation(let viewModel):
         let cell = tableView.dequeueCell(for: indexPath, type: MyLocationTableViewCell.self)
         cell.viewModel = viewModel
         return cell
      }
   }

   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)

      switch viewModel.items[indexPath.row] {
      case .weather(let weatherViewModel):
         viewModel.perform(transition: .details(weatherViewModel))

      case .myLocation(let locationViewModel):
         if case .success(let weatherViewModel) = locationViewModel.state {
            viewModel.perform(transition: .details(weatherViewModel))
         }

      default:
         break
      }
   }

   func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
      indexPaths.forEach {
         if case .weather(let vm) = viewModel.items[$0.row] {
            vm.imageViewModel.startLoading()
         }
      }
   }

   func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
      indexPaths.forEach {
         if case .weather(let vm) = viewModel.items[$0.row] {
            vm.imageViewModel.cancelLoading()
         }
      }
   }
}

extension ListViewController {

   private func setupUI() {
      tableView.rowHeight = 90
      tableView.tableFooterView = UIView()
      tableView.prefetchDataSource = self

      tableView.register(WeatherTableViewCell.self)
      tableView.register(LoadingTableViewCell.self)
      tableView.register(MyLocationTableViewCell.self)
   }

   private func addRefreshControl() {
      refreshControl = UIRefreshControl()
      refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
   }

   private func setupHandlers() {
      viewModel.viewActionHandler = { [weak self] in
         switch $0 {
         case .reload:
            self?.tableView.reloadData()
         }
      }
   }

   private func handleError(_ error: Error?) {
      guard let error = error else { return }

      let alert = UIAlertController(title: L10n.General.error, message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: L10n.General.Button.ok, style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
   }

   @objc func refreshControlAction(_ sender: UIRefreshControl) {
      loadData()
   }
}

private extension UITableView {
   
   func register(_ cellClass: UITableViewCell.Type) {
      register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
   }

   func dequeueCell<T: UITableViewCell>(for indexPath: IndexPath, type: T.Type = T.self) -> T {
      return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
   }
}
