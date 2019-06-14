//
//  WeatherAPITests.swift
//  WeatherAppTests
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class WeatherAPITests: XCTestCase {
   func testParameters_coordinates() {
      let api = WeatherAPI.weatherByCoordinates(CLLocationCoordinate2D(latitude: 1.53, longitude: 42))

      let parameters = api.parameters

      Assert.equals(parameters?["lat"], "1.53")
      Assert.equals(parameters?["lon"], "42")
   }

   func testParameters_ids() {
      let api = WeatherAPI.weatherByIDs(["1", "2", "a"])

      let parameters = api.parameters

      Assert.equals(parameters?["id"], "1,2,a")
   }
}
