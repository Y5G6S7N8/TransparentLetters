//
//  SubscriptionState.swift
//  Uchiwa202408
//
//  Created by ShinnosukeYogo on 2024/08/05.
//

import Foundation
import SwiftUI

class SubscriptionState: ObservableObject{
  @AppStorage("subscriptionState") var subscState: Bool = false
}
