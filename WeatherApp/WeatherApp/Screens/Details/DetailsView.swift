//
//  DetailsView.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class DetailsView: UIView {
   
   let imageView = WeatherImageView(frame: .zero)
   let timeLabel = UILabel()

   let windView = DetailsContentView()
   let cloudView = DetailsContentView()
   let temperature = DetailsContentView()
   let sun = DetailsContentView()

   private let stackView = UIStackView()

   override init(frame: CGRect) {
      super.init(frame: frame)
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

extension DetailsView {

   private func setupUI() {
      backgroundColor = .white

      stackView.spacing = 16
      stackView.axis = .vertical

      windView.titleLabel.text = L10n.Details.Wind.title
      cloudView.titleLabel.text = L10n.Details.Cloud.title
      temperature.titleLabel.text = L10n.Details.Temp.title
      sun.titleLabel.text = L10n.Details.Sunset.title

      timeLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize - 2)
      timeLabel.textAlignment = .center

      [imageView, windView, cloudView, temperature, sun, timeLabel, UIView()].forEach(stackView.addArrangedSubview)
      addSubview(stackView)
   }

   private func setupLayout() {
      [stackView, imageView].forEach {
         $0.translatesAutoresizingMaskIntoConstraints = false
      }
      NSLayoutConstraint.activate([
         imageView.heightAnchor.constraint(equalToConstant: 80),

         stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
         stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
         ])
   }
}
