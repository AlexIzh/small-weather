//
//  Session.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

protocol Session {
   func task(for api: API, completion: @escaping (Result<Data, Error>) -> Void) -> URLTask?
}

protocol URLTask: class {
   func resume()
   func cancel()
}

extension URLSessionTask: URLTask {}

extension URLSession: Session {
   
   func task(for api: API, completion: @escaping (Result<Data, Error>) -> Void) -> URLTask? {
      guard let request = api.makeRequest() else {
         assertionFailure("\(api) can't make a request.")
         return nil
      }

      return dataTask(with: request) { data, response, error in
         if let error = error {
            completion(.failure(error))
         } else if let data = data {
            if let response = response, let error = api.error(from: data, response: response) {
               completion(.failure(error))
            } else {
               completion(.success(data))
            }
         }
      }
   }
}
