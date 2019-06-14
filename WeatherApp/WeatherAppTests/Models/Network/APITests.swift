//
//  APITests.swift
//  WeatherAppTests
//
//  Created by Alex Severyanov on 6/13/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import XCTest
@testable import WeatherApp

class APITests: XCTestCase {
   struct TestAPI: API {
      var baseURL: URL
      var path: String
      var method: HTTPMethod
      var parameters: [String: String?]?
   }

   func testMakeRequest() {
      let api = TestAPI(baseURL: URL(string: "https://google.com")!,
                        path: "path/subpath",
                        method: .post,
                        parameters: ["first": "1", "second": "2"])

      let request = api.makeRequest()

      Assert.equals(request?.url, URL(string: "https://google.com/path/subpath?first=1&second=2"))
      Assert.equals(request?.httpMethod, HTTPMethod.post.rawValue.uppercased())
   }
}
