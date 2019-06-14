//
//  WeatherImageView.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class WeatherImageView: UIImageView {

   var viewModel: ImageViewModel? {
      didSet {
         oldValue?.viewActionHandler = {_ in}

         guard let viewModel = viewModel else { return }
         update(state: viewModel.state, animated: false)
         viewModel.viewActionHandler = { [weak self] in
            switch $0 {
            case .updateState(let state):
               self?.update(state: state, animated: true)
            }
         }
      }
   }

   private let activityIndicator = UIActivityIndicatorView(style: .gray)
   private let button = UIButton(type: .custom)

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

extension WeatherImageView {
   private func update(state: ImageViewModel.State, animated: Bool) {
      switch state {
      case .empty:
         button.isHidden = true
         activityIndicator.stopAnimating()
         image = nil
         backgroundColor = .lightGray

      case  .failed:
         backgroundColor = .clear
         button.isHidden = false
         activityIndicator.stopAnimating()
         image = nil

      case .image(let image):
         backgroundColor = .clear
         activityIndicator.stopAnimating()
         button.isHidden = true
         self.image = image

         if animated {
            let transition = CATransition()
            transition.duration = 0.2
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            transition.type = .fade
            layer.add(transition, forKey: nil)
         }

      case .loading:
         backgroundColor = .clear
         button.isHidden = true
         image = nil
         activityIndicator.startAnimating()
      }
   }
}

extension WeatherImageView {
   private func setupUI() {
      contentMode = .scaleAspectFit

      button.setImage(Asset.retry.image, for: .normal)
      activityIndicator.hidesWhenStopped = true
      [button, activityIndicator].forEach(addSubview)

      button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
   }

   private func setupLayout() {
      [button, activityIndicator].forEach {
         $0.translatesAutoresizingMaskIntoConstraints = false
      }

      NSLayoutConstraint.activate([
         activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
         activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

         button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.trailingAnchor.constraint(equalTo: trailingAnchor),
         button.topAnchor.constraint(equalTo: topAnchor),
         button.bottomAnchor.constraint(equalTo: bottomAnchor)
         ])
   }

   @objc func buttonAction(_ sender: Any?) {
      viewModel?.startLoading()
   }
}
