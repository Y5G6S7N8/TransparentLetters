//
//  TransparentLettersApp.swift
//  TransparentLetters
//
//  Created by ShinnosukeYogo on 2024/10/13.
//

import SwiftUI

@main
struct TransparentLettersApp: App {
  init() {
          IAPManager.shared.fetchProducts()
      }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
