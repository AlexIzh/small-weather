//
//  LoadingViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

class LoadingViewModel: ViewActionPerformer {
   
   enum ViewAction {
      case updateState(State)
   }

   enum State {
      case loading
      case failed
   }

   let viewQueue: DispatchQueue?
   var viewActionHandler: (ViewAction) -> Void = {_ in}
   var state: State = .loading {
      didSet {
         send(.updateState(state))
      }
   }

   init(viewQueue: DispatchQueue? = .main) {
      self.viewQueue = viewQueue
   }
}
