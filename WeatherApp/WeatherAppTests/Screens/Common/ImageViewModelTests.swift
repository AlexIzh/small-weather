//
//  ImageViewModelTests.swift
//  WeatherAppTests
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import XCTest
@testable import WeatherApp

class ImageViewModelTests: XCTestCase {

   lazy var provider = TestImageProvider()
   lazy var viewModel = ImageViewModel(id: "a", provider: provider)

   func testStartLoading_invalidID() {
      let viewModel = ImageViewModel(id: "", provider: provider)

      viewModel.startLoading()

      Assert.isNil(provider.invokedLoadID)
   }

   func testStartLoading_invalidState_loading() {
      viewModel.startLoading()
      provider.invokedLoadID = nil

      if case .loading = viewModel.state {
         viewModel.startLoading()
         Assert.isNil(provider.invokedLoadID)
      } else {
         Assert.fail(String(describing: viewModel.state))
      }
   }

   func testStartLoading_invalidState_image() {
      provider.stubbedResult = .success(UIImage(named: "10d", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
      viewModel.startLoading()
      provider.invokedLoadID = nil

      if case .image = viewModel.state {
         viewModel.startLoading()
         Assert.isNil(provider.invokedLoadID)
      } else {
         Assert.fail(String(describing: viewModel.state))
      }
   }

   func testStartLoading_changeState() {
      var isCalled = false
      viewModel.viewActionHandler = {
         if case .updateState(let state) = $0, case .loading = state {
            isCalled = true
         }
      }

      viewModel.startLoading()

      if case .loading = viewModel.state {} else {
         Assert.fail(String(describing: viewModel.state))
      }
      Assert.isTrue(isCalled)
   }

   func testStartLoading_failed() {
      provider.stubbedResult = .failure(NSError(domain: "", code: 1, userInfo: nil))
      var isCalled = false
      viewModel.viewActionHandler = {
         if case .updateState(let state) = $0, case .failed = state {
            isCalled = true
         }
      }

      viewModel.startLoading()

      if case .failed = viewModel.state {} else {
         Assert.fail(String(describing: viewModel.state))
      }
      Assert.isTrue(isCalled)
   }

   func testStartLoading_success() {
      provider.stubbedResult = .success(UIImage(named: "10d", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
      var isCalled = false
      viewModel.viewActionHandler = {
         if case .updateState(let state) = $0, case .image = state {
            isCalled = true
         }
      }

      viewModel.startLoading()

      if case .image = viewModel.state {} else {
         Assert.fail(String(describing: viewModel.state))
      }
      Assert.isTrue(isCalled)
   }

   func testCancelLoading() {
      viewModel.cancelLoading()
      Assert.isTrue(provider.isCancelled)
   }

   class TestImageProvider: ImageProvider {
      var invokedLoadID: String?
      var stubbedResult: Result<UIImage, Error>?
      func load(id: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
         invokedLoadID = id
         if let result = stubbedResult {
            completion(result)
         }
      }

      var isCancelled = false
      func cancelAll() {
         isCancelled = true
      }
   }
}
