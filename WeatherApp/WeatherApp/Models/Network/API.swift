//
//  API.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
   case get, post, delete, put
}

protocol API {
   var baseURL: URL { get }
   var path: String { get }
   var method: HTTPMethod { get }
   var parameters: [String: String?]? { get }
}

extension API {
   var baseURL: URL {
      /// default base url used for most endpoints
      return URL(string: "https://api.openweathermap.org")!
   }

   func makeRequest() -> URLRequest? {
      var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
      components?.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }.sorted  { $0.name < $1.name }
      var request = components?.url.map { URLRequest(url: $0) }
      request?.httpMethod = method.rawValue
      return request
   }
}
