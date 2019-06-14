//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

   let viewModel: DetailsViewModel

   init(viewModel: DetailsViewModel) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
   }

   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   private lazy var detailsView = DetailsView()
   override func loadView() {
      view = detailsView
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      title = viewModel.title

      detailsView.windView.detailsLabel.text = viewModel.wind
      detailsView.cloudView.detailsLabel.text = viewModel.cloud
      detailsView.temperature.detailsLabel.text = viewModel.temperature
      detailsView.sun.detailsLabel.text = viewModel.sun
      detailsView.timeLabel.text = viewModel.time
      detailsView.imageView.viewModel = viewModel.imageViewModel

      viewModel.imageViewModel.startLoading()
   }
}
