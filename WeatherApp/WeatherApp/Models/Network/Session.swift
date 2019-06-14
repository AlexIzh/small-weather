//
//  Session.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

protocol Session {
   func task(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLTask
}

protocol URLTask: class {
   func resume()
   func cancel()
}

extension URLSessionTask: URLTask {}

extension URLSession: Session {
   
   func task(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLTask {
      /// We do not handle custom messages/responses for server errors because for this project only a success result makes value for us.
      return dataTask(with: request) { data, _, error in
         if let error = error {
            completion(.failure(error))
         } else if let data = data {
            completion(.success(data))
         }
      }
   }
}
