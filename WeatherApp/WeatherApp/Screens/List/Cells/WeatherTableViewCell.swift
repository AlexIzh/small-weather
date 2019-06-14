//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

   var viewModel: WeatherViewModel? {
      didSet {
         weatherView.viewModel = viewModel
      }
   }

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

extension WeatherTableViewCell {
   private func setupUI() {
      contentView.addSubview(weatherView)
   }

   private func setupLayout() {
      weatherView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         weatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
         weatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
         weatherView.topAnchor.constraint(equalTo: contentView.topAnchor),
         weatherView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
         ])
   }
}

