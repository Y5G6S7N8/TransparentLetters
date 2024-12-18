//
//  SubscriptionView.swift
//  Preview
//
//  Created by ShinnosukeYogo on 2024/10/12.
//

import SwiftUI
import Foundation
import StoreKit

struct SubscriptionView: View {
  @State private var showingAlert = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject private var entitlementManager: EntitlementManager
  @EnvironmentObject private var purchaseManager: PurchaseManager
  @EnvironmentObject private var subscriptionState: SubscriptionState
  @StateObject private var iapManager = IAPManager.shared
  @Binding var subscriptionFlag: Bool

  private func openTermsOfService() {
    if let url = URL(string: "https://nonchalant-rainstorm-5dd.notion.site/b71a0ea3222c493c87bbef47262d214c") {
      UIApplication.shared.open(url)
    }
  }

  private func openPrivacyPolicy() {
    if let url = URL(string: "https://nonchalant-rainstorm-5dd.notion.site/181ffce6f1764c70bff086e44e6a77a8") {
      UIApplication.shared.open(url)
    }
  }

  var body: some View {
    VStack{
      Image("OnboardingImage")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.top, 8)
        .padding(.bottom, 20)
      Text("あなたの文字を、\nより美しく！")
        .font(.system(size: 35))
        .fontWeight(.heavy)
        .offset(x: 0, y: 0)
        .frame(maxWidth: 350, alignment: .leading)
        .padding(.bottom, 20)
      HStack{
        Text("●")
          .frame(maxWidth: 16, alignment: .leading)
          .foregroundColor(Color.main)
        Text("解約金なしで３日間は無料のお試しができます！")
          .fontWeight(.bold)
          .font(.system(size: 15))
          .frame(maxWidth: 340, alignment: .leading)
          .foregroundColor(Color.textLightGray)
      }
      .padding(.bottom, 15)
      HStack{
        Text("●")
          .frame(maxWidth: 16, alignment: .leading)
          .foregroundColor(Color.main)
        Text("無料のお試し後は、週額200円で継続することが可能")
          .fontWeight(.bold)
          .font(.system(size: 15))
          .frame(maxWidth: 340, alignment: .leading)
          .foregroundColor(Color.textLightGray)
      }
      .padding(.bottom, 15)
      HStack{
        Text("●")
          .frame(maxWidth: 16, alignment: .leading)
          .foregroundColor(Color.main)
        Text("画面下の「無料で開始する」ボタンを押すと、\n文字サイズ、フォント、保存機能などすべての機能が使い放題！")
          .fontWeight(.bold)
          .font(.system(size: 15))
          .frame(maxWidth: 340, alignment: .leading)
          .foregroundColor(Color.textLightGray)
      }
      .padding(.bottom, 10)
      Text("AppleStoreからいつでもキャンセルできます")
        .fontWeight(.bold)
        .font(.system(size: 12))
        .frame(maxWidth: 340)
        .foregroundColor(Color.textLightGray)
      Spacer()
      Spacer()
      Spacer()
      Spacer()
      Spacer()
      VStack(spacing: 20) {
        if entitlementManager.hasPro {
          Text("すでに購入済みです")
            .onAppear(perform: {
              subscriptionFlag = true
            })
        } else {
          ForEach(purchaseManager.products) { product in
            Button {
              _ = Task<Void, Never> {
                do {
                  try await purchaseManager.purchase(product)
                } catch {
                  print(error)
                }
              }
            } label: {
              Text("無料で開始する　　　　　　　　　　　　　")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(.black)
                .clipShape(Capsule())
                .frame(width: 380, height: 70)
                .cornerRadius(10)
            }
            .onAppear {
                iapManager.fetchProducts()
            }
          }
        }
      }
      Spacer()

      HStack(spacing: 80) {
        Button("利用規約") {
          openTermsOfService()
        }
        .foregroundColor(Color.textLightGray)
        .font(.system(size: 12))

        Button("プライバシーポリシー") {
          openPrivacyPolicy()
        }
        .foregroundColor(Color.textLightGray)
        .font(.system(size: 12))

        Button("復元") {
          //                      restorePurchases()
          _ = Task<Void, Never> {
            do {
              try await AppStore.sync()
            } catch {
              print(error)
            }
          } // task
        } // button
        .foregroundColor(Color.textLightGray)
        .font(.system(size: 12))
        .task {
          _ = Task<Void, Never> {
            do {
              try await purchaseManager.loadProducts()
            } catch {
              print(error)
            }
          }
        } // task
      }
      .alert(isPresented: $showingAlert) {
        Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
      }
      //Spacer()
        .padding(.bottom, 5)
    } // VStack
  } // ZStack
} // body


