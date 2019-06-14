//
//  WeatherImageLoader.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

protocol ImageLoader {
   func load(id: String, completion: @escaping (Result<UIImage, Swift.Error>) -> Void)
   func cancelAll()
}

final class WeatherImageLoader: DataLoader, ImageLoader {

   enum Error: Swift.Error {
      case invalidData
   }

   override init(session: Session = URLSession.imagesSession) {
      super.init(session: session)
   }

   func load(id: String, completion: @escaping (Result<UIImage, Swift.Error>) -> Void) {
      runRequest(with: WeatherAPI.image(id)) {
         completion($0.flatMap {
            UIImage(data: $0).map { .success($0) } ?? .failure(Error.invalidData)
         })
      }
   }
}

extension URLSession {
   static let imagesSession = makeImagesSession()

   private static func makeImagesSession() -> URLSession {
      let configuration = URLSessionConfiguration.default
      configuration.requestCachePolicy = .returnCacheDataElseLoad
      configuration.urlCache = URLCache(memoryCapacity: 30 * 1024 * 1024,
                                        diskCapacity: 100 * 1024 * 1024,
                                        diskPath: nil)

      return URLSession(configuration: configuration)
   }
}
