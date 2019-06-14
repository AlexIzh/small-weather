//
//  DataLoader.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

class DataLoader {
   let session: Session

   private var tasks: [WeakURLTask] = []

   init(session: Session) {
      self.session = session
   }

   deinit {
      cancelAll()
   }
}

extension DataLoader {
   @discardableResult
   func runRequest(with api: API, completion: @escaping (Result<Data, Error>) -> Void) -> URLTask? {
      guard let request = api.makeRequest() else { return nil }

      let task = session.task(with: request, completion: completion)
      task.resume()
      tasks.append(WeakURLTask(task))
      return task
   }

   func cancelAll() {
      tasks.forEach { $0.cancel() }
      tasks.removeAll()
   }
}

private class WeakURLTask {

   private weak var task: URLTask?

   init(_ task: URLTask) {
      self.task = task
   }

   func cancel() {
      task?.cancel()
   }
}
