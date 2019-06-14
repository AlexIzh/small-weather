//
//  LoadingTableViewCell.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

   var viewModel: LoadingViewModel? {
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

   var retryHandler: () -> Void = {}

   private let activityIndicator = UIActivityIndicatorView(style: .gray)
   private let button = UIButton(type: .system)

   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      initialize()
   }

   required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initialize()
   }

   private func initialize() {
      setupUI()
      setupLayout()
   }
}

extension LoadingTableViewCell {
   private func update(state: LoadingViewModel.State) {
      switch state {
      case .failed:
         activityIndicator.stopAnimating()
         button.isHidden = false

      case .loading:
         button.isHidden = true
         activityIndicator.startAnimating()
      }
   }
}

extension LoadingTableViewCell {
   private func setupUI() {
      button.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
      button.setTitle(L10n.List.Cities.tryAgain, for: .normal)

      activityIndicator.hidesWhenStopped = true
      [button, activityIndicator].forEach(contentView.addSubview)

      button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
   }

   private func setupLayout() {
      [button, activityIndicator].forEach {
         $0.translatesAutoresizingMaskIntoConstraints = false
      }

      NSLayoutConstraint.activate([
         activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

         button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         button.topAnchor.constraint(equalTo: contentView.topAnchor),
         button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
         ])
   }

   @objc func buttonAction(_ sender: Any?) {
      retryHandler()
   }
}
