//
//  LoadingViewModelTests.swift
//  WeatherAppTests
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import XCTest
@testable import WeatherApp

class LoadingViewModelTests: XCTestCase {
   func testStateChange() {
      let viewModel = LoadingViewModel()
      var states: [LoadingViewModel.State] = []
      viewModel.viewActionHandler = {
         if case .updateState(let state) = $0 {
            states.append(state)
         }
      }

      viewModel.state = .failed
      viewModel.state = .loading
      viewModel.state = .failed

      Assert.equals(states, [.failed, .loading, .failed])
   }
}
