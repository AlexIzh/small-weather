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

   let id: String

   var viewActionHandler: (ViewAction) -> Void = {_ in}
   private(set) var state: State = .empty

   private let provider: ImageProvider

   init(id: String, provider: ImageProvider = WeatherImageProvider()) {
      self.id = id
      self.provider = provider
   }
}

extension ImageViewModel {
   func startLoading() {
      guard !id.isEmpty else { return }
      if case .loading = state { return }
      if case .image = state { return }

      state = .loading
      send(.updateState(state))

      provider.load(id: id) { [weak self] in
         let state: State = (try? $0.get()).map { .image($0) } ?? .failed
         self?.state = state
         self?.send(.updateState(state))
      }
   }

   func cancelLoading() {
      provider.cancelAll()
   }
}
