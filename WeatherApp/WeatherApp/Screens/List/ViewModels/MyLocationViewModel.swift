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

   var viewActionHandler: (ViewAction) -> Void = {_ in}
   var state: State = .loading

   private let locationManager = LocationManager()
   private let provider: WeatherDataProvider
   private let settingsOpener: SettingsOpener

   init(provider: WeatherDataProvider = .init(), settingsOpener: SettingsOpener = UIApplication.shared) {
      self.provider = provider
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
            if self.locationManager.authorizationStatus != .authorizedWhenInUse {
               self.state = .noPermissions
            } else {
               self.state = .retry
            }
            self.send(.updateState(self.state))

         case .success(let location):
            self.loadWeather(for: location)
         }
      }
   }

   private func loadWeather(for location: CLLocationCoordinate2D) {
      provider.weather(coordinates: location) { [weak self] in
         let state: State = (try? $0.get()).map {
            let viewModel = MyLocationWeatherViewModel($0)
            viewModel.imageViewModel.startLoading()
            return .success(viewModel)
         } ?? .retry

         self?.state = state
         self?.send(.updateState(state))
      }
   }
}

class MyLocationWeatherViewModel: WeatherViewModel {
   override var title: String {
      return L10n.List.MyLocation.title(super.title)
   }
}
