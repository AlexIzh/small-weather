//
//  MyLocationTableViewCell.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class MyLocationTableViewCell: UITableViewCell {
   
   var viewModel: MyLocationViewModel? {
      didSet {
         oldValue?.viewActionHandler = {_ in}

         guard let viewModel = viewModel else { return }
         update(state: viewModel.state)
         viewModel.viewActionHandler = { [weak self] in
            switch $0 {
            case .updateState(let state):
               self?.update(state: state)
            }
         }
      }
   }

   private let activityIndicator = UIActivityIndicatorView(style: .gray)
   private let button = UIButton(type: .system)
   private let weatherView = WeatherContentView()

   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      initialize()
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initialize()
   }

   func initialize() {
      setupUI()
      setupLayout()
   }
}

extension MyLocationTableViewCell {
   private func update(state: MyLocationViewModel.State) {
      activityIndicator.stopAnimating()
      weatherView.isHidden = true
      button.isHidden = true
      button.removeTarget(nil, action: nil, for: .allEvents)

      switch state {
      case .loading:
         activityIndicator.startAnimating()

      case .noPermissions:
         button.isHidden = false
         button.setTitle(L10n.List.MyLocation.permission, for: .normal)
         button.addTarget(self, action: #selector(permissionsAction), for: .touchUpInside)

      case .retry:
         button.isHidden = false
         button.setTitle(L10n.List.MyLocation.tryAgain, for: .normal)
         button.addTarget(self, action: #selector(retryAction), for: .touchUpInside)

      case .success(let weather):
         weatherView.isHidden = false
         weatherView.viewModel = weather
      }
   }
}

extension MyLocationTableViewCell {
   private func setupUI() {
      button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

      activityIndicator.hidesWhenStopped = true
      [weatherView, activityIndicator, button].forEach(contentView.addSubview)

      button.setContentHuggingPriority(.defaultLow, for: .vertical)
   }

   private func setupLayout() {
      [button, activityIndicator, weatherView].forEach {
         $0.translatesAutoresizingMaskIntoConstraints = false
      }

      NSLayoutConstraint.activate([
         activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

         button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         button.topAnchor.constraint(equalTo: contentView.topAnchor),
         button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

         weatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         weatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         weatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
         weatherView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
         ])
   }

   @objc func retryAction(_ sender: Any?) {
      viewModel?.startLoading()
   }

   @objc func permissionsAction(_ sender: Any?) {
      viewModel?.openSettings()
   }
}
