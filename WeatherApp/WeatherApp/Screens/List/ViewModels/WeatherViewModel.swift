//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

class WeatherViewModel {
   let weather: Weather
   let imageViewModel: ImageViewModel

   var title: String {
      return weather.name
   }

   var subtitle: String {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      func string(from value: Double) -> String {
         return formatter.string(from: NSNumber(value: value))!
      }
      return L10n.Details.Temp.description(string(from: weather.main.temperature),
                                           string(from: weather.main.minTemperature),
                                           string(from: weather.main.maxTemperature))
   }

   init(_ weather: Weather) {
      self.weather = weather
      imageViewModel = ImageViewModel(id: weather.weather.first?.icon ?? "")
   }
}
