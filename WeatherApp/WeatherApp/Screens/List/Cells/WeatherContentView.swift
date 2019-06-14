//
//  WeatherContentView.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class WeatherContentView: UIStackView {
   var viewModel: WeatherViewModel? {
      didSet {
         titleLabel.text = viewModel?.title ?? ""
         subtitleLabel.text = viewModel?.subtitle ?? ""
         imageContainerView.weatherImageView.viewModel = viewModel?.imageViewModel
      }
   }

   private let imageContainerView = ImageContainerView(frame: .zero)
   private let titleLabel = UILabel()
   private let subtitleLabel = UILabel()

   private let textsStackView = UIStackView()

   override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
   }

   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initialize()
   }

   private func initialize() {
      setupUI()
   }
}

extension WeatherContentView {
   private func setupUI() {
      axis = .horizontal
      layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
      isLayoutMarginsRelativeArrangement = true
      spacing = 8

      textsStackView.axis = .vertical
      textsStackView.spacing = 8

      subtitleLabel.numberOfLines = 3
      subtitleLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

      [imageContainerView, textsStackView].forEach(addArrangedSubview)
      [titleLabel, subtitleLabel].forEach(textsStackView.addArrangedSubview)
   }
}

private class ImageContainerView: UIView {
   let weatherImageView = WeatherImageView(frame: .zero)

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

extension ImageContainerView {
   private func setupUI() {
      addSubview(weatherImageView)
   }

   private  func setupLayout() {
      weatherImageView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
         weatherImageView.widthAnchor.constraint(equalToConstant: 50),
         
         weatherImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
         weatherImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
         weatherImageView.topAnchor.constraint(equalTo: topAnchor),
         weatherImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor),
         weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
         ])
   }
}

