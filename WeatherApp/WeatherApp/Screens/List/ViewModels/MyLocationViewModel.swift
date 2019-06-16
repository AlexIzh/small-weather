//
//  MyLocationViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingsOpener {
   func openSettings()
}

extension UIApplication: SettingsOpener {
   
   func openSettings() {
      if let url = URL(string: UIApplication.openSettingsURLString) {
         open(url, options: [:], completionHandler: nil)
      }
   }
}

class MyLocationViewModel: ViewActionPerformer {

   enum ViewAction {
      case updateState(State)
   }

   enum State {
      case loading
      case noPermissions
      case retry
      case success(WeatherViewModel)
   }

   let viewQueue: DispatchQueue?
   var viewActionHandler: (ViewAction) -> Void = {_ in}
   var state: State = .loading

   private let locationManager = LocationManager()
   private let loader: WeatherDataProvider
   private let settingsOpener: SettingsOpener

   init(viewQueue: DispatchQueue? = .main, loader: WeatherDataProvider = .init(), settingsOpener: SettingsOpener = UIApplication.shared) {
      self.viewQueue = viewQueue
      self.loader = loader
      self.settingsOpener = settingsOpener

      locationManager.authorizationChanged = { [unowned self] in
         if case .loading = self.state { return }

         if $0 == .authorizedWhenInUse {
            self.startLoading()
         }
      }
   }
}

extension MyLocationViewModel {
   func openSettings() {
      settingsOpener.openSettings()
   }

   func startLoading() {
      state = .loading
      locationManager.requestOnce { [unowned self] in
         switch $0 {
         case .failure:
            self.executeViewActions {
               if self.locationManager.authorizationStatus != .authorizedWhenInUse {
                  self.state = .noPermissions
               } else {
                  self.state = .retry
               }
               $0.send(.updateState($0.state), async: false)
            }

         case .success(let location):
            self.loadWeather(for: location)
         }
      }
   }

   private func loadWeather(for location: CLLocationCoordinate2D) {
      loader.weather(coordinates: location) { [weak self] result in
         self?.executeViewActions {
            switch result {
            case .failure:
               $0.state = .retry

            case .success(let weather):
               let viewModel = MyLocationWeatherViewModel(weather)
               viewModel.imageViewModel.startLoading()
               $0.state = .success(viewModel)
            }
            $0.send(.updateState($0.state), async: false)
         }
      }
   }
}

class MyLocationWeatherViewModel: WeatherViewModel {
   override var title: String {
      return L10n.List.MyLocation.title(super.title)
   }
}
