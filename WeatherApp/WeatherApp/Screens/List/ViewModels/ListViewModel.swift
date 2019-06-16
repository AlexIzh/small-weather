//
//  ListViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

class ListViewModel: ViewActionPerformer, TransitionPerformer {

   enum ViewAction {
      case reload
   }

   enum Transition {
      case details(WeatherViewModel)
   }

   enum Item {
      case myLocation(MyLocationViewModel)
      case loading(LoadingViewModel)
      case weather(WeatherViewModel)
   }

   let viewQueue: DispatchQueue?
   var viewActionHandler: (ViewAction) -> Void = {_ in}
   var transitionHandler: (Transition) -> Void = {_ in}
   var items: [Item]

   private let loader: WeatherDataProvider
   private let loadingViewModel: LoadingViewModel
   private let myLocationViewModel: MyLocationViewModel

   init(viewQueue: DispatchQueue? = .main, loader: WeatherDataProvider = .init()) {
      self.viewQueue = viewQueue
      self.loader = loader

      myLocationViewModel = MyLocationViewModel(viewQueue: viewQueue, loader: loader)
      loadingViewModel = LoadingViewModel(viewQueue: viewQueue)
      items = [.myLocation(myLocationViewModel), .loading(loadingViewModel)]
   }
}

extension ListViewModel {
   func startLoading(_ completion: @escaping (Error?) -> Void) {
      myLocationViewModel.startLoading()
      loadingViewModel.state = .loading
      loader.weatherForCities { [weak self] in
         switch $0 {
         case .failure(let error):
            self?.loadingViewModel.state = .failed
            self?.executeViewActions {_ in completion(error)  }

         case .success(let items):
            self?.executeViewActions {
               $0.items = [.myLocation($0.myLocationViewModel)] + items.map { .weather(WeatherViewModel($0)) }
               $0.send(.reload, async: false)
               completion(nil)
            }
         }
      }
   }
}
