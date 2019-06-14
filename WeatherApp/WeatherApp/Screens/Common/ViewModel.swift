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
   var viewQueue: DispatchQueue? { get }

   func send(_ action: ViewAction, async: Bool)
}

extension ViewActionPerformer {
   func send(_ action: ViewAction, async: Bool = true) {
      if let queue = viewQueue, async {
         queue.async { [weak self] in self?.viewActionHandler(action) }
      } else {
         viewActionHandler(action)
      }
   }

   func executeViewActions(_ closure: @escaping (Self) -> Void) {
      if let queue = viewQueue {
         queue.async { [weak self] in self.map { closure($0) } }
      } else {
         closure(self)
      }
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
