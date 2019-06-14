//
//  WeatherAPI.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation
import CoreLocation

enum WeatherAPI: API {
   case weatherByIDs([String])
   case weatherByCoordinates(CLLocationCoordinate2D)

   case image(String)

   var path: String {
      switch self {
      case .image(let id):
         return "img/w/\(id).png"

      case .weatherByIDs:
         return "data/2.5/group"

      case .weatherByCoordinates:
         return "data/2.5/weather"
      }
   }

   var parameters: [String: String?]? {
      var dic = ["appid": "4f37aab0a9a6edcafdfb8a5874202164"]
      switch self {
      case .weatherByCoordinates(let coordinates):
         let formatter = NumberFormatter()
         formatter.numberStyle = .decimal
         formatter.locale = Locale(identifier: "en_US_POSIX")

         dic["lat"] = formatter.string(from: NSNumber(value: coordinates.latitude))
         dic["lon"] = formatter.string(from: NSNumber(value: coordinates.longitude))
         return dic

      case .weatherByIDs(let ids):
         dic["id"] = ids.joined(separator: ",")
         return dic

      case .image:
         return nil
      }
   }

   var method: HTTPMethod {
      return .get
   }
}
