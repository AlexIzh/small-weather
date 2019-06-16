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

   var viewActionHandler: (ViewAction) -> Void = {_ in}
   var transitionHandler: (Transition) -> Void = {_ in}
   var items: [Item]

   private let provider: WeatherDataProvider
   private let loadingViewModel: LoadingViewModel
   private let myLocationViewModel: MyLocationViewModel

   init(provider: WeatherDataProvider = .init()) {
      self.provider = provider

      myLocationViewModel = MyLocationViewModel(provider: provider)
      loadingViewModel = LoadingViewModel()
      items = [.myLocation(myLocationViewModel), .loading(loadingViewModel)]
   }
}

extension ListViewModel {
   func startLoading(_ completion: @escaping (Error?) -> Void) {
      myLocationViewModel.startLoading()
      loadingViewModel.state = .loading
      provider.weatherForCities { [weak self] in
         switch $0 {
         case .failure(let error):
            self?.loadingViewModel.state = .failed
            completion(error)

         case .success(let items):
            if let self = self  {
               self.items = [.myLocation(self.myLocationViewModel)] + items.map { .weather(WeatherViewModel($0)) }
               self.send(.reload)
            }
            completion(nil)
         }
      }
   }
}
