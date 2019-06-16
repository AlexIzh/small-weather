//
//  DataProviderTests.swift
//  WeatherAppTests
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import XCTest
@testable import WeatherApp

class DataProviderTests: XCTestCase {
   func testStartRequest_success() {
      let session = TestSession()
      session.stubbedTaskCompletionParams = .success(Data())

      let loader = DataProvider(session: session, responseQueue: nil)
      var isCompletionCalled = false

      let task = loader.startRequest(for: makeAPI()) {
         isCompletionCalled = (try? $0.get()) != nil
      } as! TestTask

      Assert.isTrue(isCompletionCalled)
      Assert.isTrue(task.isResumed)
      Assert.isTrue(session.invokedTaskParam is APITests.TestAPI)
   }

   func testStartRequest_error() {
      let session = TestSession()
      session.stubbedTaskCompletionParams = .failure(NSError(domain: "", code: 1, userInfo: nil))

      let loader = DataProvider(session: session, responseQueue: nil)
      var isCompletionCalled = false

      loader.startRequest(for: makeAPI()) {
         isCompletionCalled = (try? $0.get()) == nil
      }

      Assert.isTrue(isCompletionCalled)
   }

   func testCancelAll() {
      let session = TestSession()
      let loader = DataProvider(session: session, responseQueue: nil)
      loader.startRequest(for: makeAPI(), completion: {_ in})

      loader.cancelAll()

      Assert.isTrue(session.stubbedTaskResult.isCancelled)
   }

   func testCancelWhenDeinit() {
      let session = TestSession()

      do {
         let loader = DataProvider(session: session, responseQueue: nil)
         loader.startRequest(for: makeAPI(), completion: {_ in})
      }

      Assert.isTrue(session.stubbedTaskResult.isCancelled)
   }

   private  func makeAPI() -> API {
      return APITests.TestAPI(baseURL: URL(string: "a")!, path: "", method: .get, parameters: nil)
   }
}

extension DataProviderTests {
   class TestSession: Session {
      var invokedTaskParam: API?
      var stubbedTaskCompletionParams: Result<Data, Error>?
      var stubbedTaskResult = TestTask()

      func task(for api: API, completion: @escaping (Result<Data, Error>) -> Void) -> URLTask? {
         invokedTaskParam = api
         if let params = stubbedTaskCompletionParams {
            completion(params)
         }
         return stubbedTaskResult
      }
   }

   class TestTask: URLTask {
      var isResumed = false
      var isCancelled = false

      func resume() {
         isResumed = true
      }

      func cancel() {
         isCancelled = true
      }
   }
}
