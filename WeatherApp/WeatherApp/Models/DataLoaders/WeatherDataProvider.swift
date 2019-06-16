//
//  WeatherDataProvider.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation
import CoreLocation

final class WeatherDataProvider: DataProvider {

   override init(session: Session = URLSession.shared) {
      super.init(session: session)
   }

   func weather(coordinates: CLLocationCoordinate2D, completion: @escaping (Result<Weather, Error>) -> Void) {
      runRequest(with: WeatherAPI.weatherByCoordinates(coordinates)) {
         completion($0.flatMap {
            do {
               let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .secondsSince1970
               return .success(try decoder.decode(Weather.self, from: $0))
            } catch {
               return .failure(error)
            }
         })
      }
   }

   func weatherForCities(completion: @escaping (Result<[Weather], Error>) -> Void) {
      /// ids could be moved to parameters if we need to possibility to add/remove cities from a list
      let ids = ["2643741", "1850147"]
      runRequest(with: WeatherAPI.weatherByIDs(ids)) {
         completion($0.flatMap {
            do {
               let decoder = JSONDecoder()
               decoder.dateDecodingStrategy = .secondsSince1970
               let group = try decoder.decode(Group.self, from: $0)
               return .success(group.list)
            } catch {
               return .failure(error)
            }
         })
      }
   }
}

private struct Group: Decodable {
   let list: [Weather]
}
