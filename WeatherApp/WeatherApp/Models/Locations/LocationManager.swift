//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {

   var authorizationChanged: (CLAuthorizationStatus) -> Void = {_ in}
   var authorizationStatus: CLAuthorizationStatus {
      return CLLocationManager.authorizationStatus()
   }

   private let manager = CLLocationManager()
   private var completions: [(Result<CLLocationCoordinate2D, Error>) -> Void] = []

   override init() {
      super.init()

      manager.desiredAccuracy = kCLLocationAccuracyBest
      manager.delegate = self
   }

   deinit {
      stop()
   }
}

extension LocationManager {

   func requestOnce(completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
      manager.requestWhenInUseAuthorization()
      manager.requestLocation()

      completions.append(completion)
   }

   func stop() {
      manager.stopUpdatingLocation()
      completions.removeAll()
   }

   func requestAuthorization() {
      manager.requestWhenInUseAuthorization()
   }
}

extension LocationManager: CLLocationManagerDelegate {

   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      authorizationChanged(status)
   }

   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      if let location = locations.last {
         completions.forEach { $0(.success(location.coordinate)) }
         completions.removeAll()
      }
   }

   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      completions.forEach { $0(.failure(error)) }
      completions.removeAll()
   }
}
