//
//  DetailsViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

class DetailsViewModel {

   let weather: Weather
   let imageViewModel: ImageViewModel

   private let formatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      return formatter
   }()

   init(_ weather: Weather) {
      self.weather = weather
      imageViewModel = ImageViewModel(id: weather.weather.first?.icon ?? "")
   }
}

extension DetailsViewModel {

   var title: String {
      return weather.name
   }

   var wind: String {
      return L10n.Details.Wind.description(string(from: weather.wind.speed),
                                           string(from: weather.wind.degrees))
   }

   var cloud: String {
      return L10n.Details.Cloud.description(string(from: weather.clouds.cloudiness))
   }

   var temperature: String {
      return L10n.Details.Temp.description(string(from: weather.main.temperature),
                                           string(from: weather.main.minTemperature),
                                           string(from: weather.main.maxTemperature))
   }

   var sun: String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .none
      dateFormatter.timeStyle = .medium
      return L10n.Details.Sunset.description(dateFormatter.string(from: weather.sys.sunrise),
                                             dateFormatter.string(from: weather.sys.sunset))
   }

   var time: String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateStyle = .short
      dateFormatter.timeStyle = .short
      return L10n.Details.time(dateFormatter.string(from: weather.time))
   }
}

extension DetailsViewModel {

   private func string(from value: Double) -> String {
      return formatter.string(from: NSNumber(value: value))!
   }
}
