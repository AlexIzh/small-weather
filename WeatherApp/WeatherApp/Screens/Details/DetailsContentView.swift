//
//  DetailsContentView.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class DetailsContentView: UIStackView {
   
   let titleLabel = UILabel()
   let detailsLabel = UILabel()

   override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
   }

   required init(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      initialize()
   }

   private func initialize() {
      axis = .vertical
      alignment = .center
      spacing = 4

      titleLabel.textAlignment = .center
      titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)

      detailsLabel.numberOfLines = 0
      detailsLabel.textAlignment = .center
      detailsLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

      addArrangedSubview(titleLabel)
      addArrangedSubview(detailsLabel)
   }
}
