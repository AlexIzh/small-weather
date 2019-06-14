//
//  MainCoordinator.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class MainCoordinator {
   
   func instantiateInitialController() -> UIViewController {
      let list = ListViewController()
      let navigation = UINavigationController(rootViewController: list)

      list.viewModel.transitionHandler = { [weak navigation, weak self] in
         switch $0 {
         case .details(let viewModel):
            if let controller = self?.instantiateDetailsController(for: viewModel) {
               navigation?.pushViewController(controller, animated: true)
            }
         }
      }

      return navigation
   }

   private func instantiateDetailsController(for viewModel: WeatherViewModel) -> UIViewController {
      return DetailsViewController(viewModel: .init(viewModel.weather))
   }
}
