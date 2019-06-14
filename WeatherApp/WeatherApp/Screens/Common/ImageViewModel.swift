//
//  ImageViewModel.swift
//  WeatherApp
//
//  Created by Alex Severyanov on 6/14/19.
//  Copyright © 2019 Alex Severyanov. All rights reserved.
//

import UIKit

class ImageViewModel: ViewActionPerformer {
   enum ViewAction {
      case updateState(State)
   }

   enum State {
      case empty
      case loading
      case failed
      case image(UIImage)
   }

   let viewQueue: DispatchQueue?
   let loader: ImageLoader
   let id: String

   var viewActionHandler: (ViewAction) -> Void = {_ in}
   private(set) var state: State = .empty

   init(id: String, viewQueue: DispatchQueue? = .main, loader: ImageLoader = WeatherImageLoader()) {
      self.id = id
      self.viewQueue = viewQueue
      self.loader = loader
   }
}

extension ImageViewModel {
   func startLoading() {
      guard !id.isEmpty else { return }
      if case .loading = state { return }
      if case .image = state { return }

      state = .loading
      send(.updateState(state))

      loader.load(id: id) {
         switch $0 {
         case .success(let image):
            self.state = .image(image)
         case .failure:
            self.state = .failed
         }
         self.send(.updateState(self.state))
      }
   }

   func cancelLoading() {
      loader.cancelAll()
   }
}
