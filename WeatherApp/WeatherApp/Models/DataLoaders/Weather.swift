//
//  Weather.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

struct Weather: Decodable {
   let id: Int
   let name: String
   let time: Date
   
   let weather: [WeatherInfo]
   let main: Main
   let wind: Wind
   let clouds: Clouds
   let rain: Precipitation?
   let snow: Precipitation?
   let sys: Sys

   private enum CodingKeys: String, CodingKey {
      case id, name, weather, main, wind, clouds, rain, snow, sys
      case time = "dt"
   }
}

struct WeatherInfo: Decodable {
   let id: Int
   let main: String
   let description: String
   let icon: String
}

struct Precipitation: Decodable {
   let oneHourAgo: Double?
   let threeHoursAgo: Double?

   private enum CodingKeys: String, CodingKey {
      case oneHourAgo = "1h"
      case threeHoursAgo = "3h"
   }
}

struct Main: Decodable {
   let temperature: Double
   let humidity: Double
   let minTemperature: Double
   let maxTemperature: Double

   let pressure: Double?
   let seaPressure: Double?
   let groundPressure: Double?

   var atmospherePressure: Double? {
      return seaPressure ?? groundPressure ?? pressure
   }

   private enum CodingKeys: String, CodingKey {
      case temperature = "temp"
      case humidity
      case minTemperature = "temp_min"
      case maxTemperature = "temp_max"

      case pressure
      case seaPressure = "sea_level"
      case groundPressure = "grnd_level"
   }
}

struct Wind: Decodable {
   let speed: Double
   let degrees: Double

   private enum CodingKeys: String, CodingKey {
      case speed, degrees = "deg"
   }
}

struct Clouds: Decodable {
   let cloudiness: Double

   private enum CodingKeys: String, CodingKey {
      case cloudiness = "all"
   }
}

struct Sys: Decodable {
   let sunrise: Date
   let sunset: Date
}
