//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import Foundation

protocol ViewActionPerformer: class {
   associatedtype ViewAction

   var viewActionHandler: (ViewAction) -> Void { get set }
   func send(_ action: ViewAction)
}

extension ViewActionPerformer {
   func send(_ action: ViewAction) {
      viewActionHandler(action)
   }
}

protocol TransitionPerformer {
   associatedtype Transition

   var transitionHandler: (Transition) -> Void { get set }
   func perform(transition: Transition)
}

extension  TransitionPerformer {
   func perform(transition: Transition) {
      transitionHandler(transition)
   }
}
