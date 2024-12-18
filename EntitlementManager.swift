//
//  EntitlementManager.swift
//  Uchiwa202408
//
//  Created by ShinnosukeYogo on 2024/08/05.
//

import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("hasPro", store: userDefaults) var hasPro: Bool = false
}
