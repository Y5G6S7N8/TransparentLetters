//
//  ContentView.swift
//  TransparentLetters
//
//  Created by ShinnosukeYogo on 2024/10/13.
//

import SwiftUI
import Foundation
import StoreKit

struct ContentView: View {
    @StateObject private var iapManager = IAPManager.shared
    @StateObject var entitlementManager: EntitlementManager
    @StateObject var purchaseManager: PurchaseManager
    @StateObject var subscriptionState = SubscriptionState()
    @State private var showSubscription = false
    @State private var showKeepImage = false
    @State private var inputText = "御祝儀"
    @State private var selectedFont = "medium"
    @State private var selectedColor = "黒"
    @State private var showSecondView = false
    @State private var textDegress = true
    @State private var textSize: Int = 48
    @State private var isShowAlert = false
    @State var showKeepDataView: Bool = false
  @AppStorage("subscriptionFlag") private var subscriptionFlag: Bool = false

  init() {
    let entitlementManager = EntitlementManager()
    let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)

    self._entitlementManager = StateObject(wrappedValue: entitlementManager)
    self._purchaseManager = StateObject(wrappedValue: purchaseManager)
  }

    var body: some View {
        NavigationView {
          VStack {
              HStack {
                Spacer()
                if subscriptionFlag == false {
                  Button(action: {
                    showSubscription = true
                  }) {
                    Image(systemName: "crown.fill")
                      .imageScale(.large)
                      .frame(width: 80, height: 50)
                      .foregroundColor(Color(red: 1, green: 0.8, blue: 0.04, opacity: 1.0))
                      .background(Color.black)
                      .cornerRadius(10)
                  }.sheet(isPresented: $showSubscription){
                    SubscriptionView(subscriptionFlag: $subscriptionFlag)
                      .environmentObject(entitlementManager)
                      .environmentObject(purchaseManager)
                      .task {
                        await purchaseManager.updatePurchasedProducts()
                      }
                  }
                  .padding(.trailing)
                }
              }

            if textDegress == true {
              HStack {
                Spacer()
                VStack {
                  ForEach(Array(inputText), id: \.self) { char in
                    Text(String(char))
                      .font(Font.custom(selectedFont, size: 48))
                  }
                }
                Spacer()
              }
              .frame(height: 299)
            }
            else{
              Text(inputText)
                .font(Font.custom(selectedFont, size: 48))
                .rotationEffect(.degrees(90))
                .padding()
                .frame(height: 299)
                .kerning(10)
            }
            Spacer()
            HStack{
              Text("文字")
                .padding(.horizontal)
              TextField("テキストを入力", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            }
            HStack {
              if subscriptionFlag == true {
                Text("フォント(制限なし)")
                  .padding()
                Spacer()
                Picker("フォント", selection: $selectedFont) {
                  Text("Default").tag("heavy")
                  Text("HinaMincho").tag("HinaMincho-Regular")
                  Text("Times-New-Romance").tag("Times-New-Romance")
                  Text("KaiseiOpti").tag("KaiseiOpti-Regular")
                  Text("ZenAntique").tag("ZenAntique-Regular")
                  Text("NotoSansJP").tag("NotoSansJP-Regular")
                  Text("MPLUSRounded1c").tag("MPLUSRounded1c-Regular")
                  Text("KaiseiTokumin").tag("KaiseiTokumin-Regular")
                  Text("RampartOne").tag("RampartOne-Regular")
                  Text("NotoSerifJP").tag("NotoSerifJP-Regular")
                  Text("MochiyPopPOne").tag("MochiyPopPOne-Regular")
                  Text("YujiSyuku").tag("YujiSyuku-Regular")
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
              }
              else{
                Text("フォント(制限あり)")
                  .padding()
                Spacer()
                Picker("フォント", selection: $selectedFont) {
                  Text("Default").tag("heavy")
                  Text("👑HinaMincho").tag("P")
                  Text("👑Times-New-Romance").tag("P")
                  Text("👑KaiseiOpti").tag("P")
                  Text("👑ZenAntique").tag("P")
                  Text("👑NotoSansJP").tag("P")
                  Text("👑MPLUSRounded1c").tag("P")
                  Text("👑KaiseiTokumin").tag("P")
                  Text("👑RampartOne").tag("P")
                  Text("👑NotoSerifJP").tag("P")
                  Text("👑MochiyPopPOne").tag("P")
                  Text("👑YujiSyuku").tag("P")
                }
                .pickerStyle(MenuPickerStyle())
                .padding(.horizontal)
              }
            }
            HStack {
              Text("大きさ")
                .padding()
              Spacer()
              Picker("大きさ", selection: $textSize) {
                if subscriptionFlag == true {
                  Text("48").tag(48)
                  Text("60").tag(60)
                  Text("72").tag(72)
                  Text("84").tag(84)
                  Text("96").tag(96)
                  Text("108").tag(108)
                }
                else
                {
                  Text("48").tag(48)
                  Text("👑60").tag(9)
                  Text("👑72").tag(9)
                  Text("👑84").tag(9)
                  Text("👑96").tag(9)
                  Text("👑108").tag(9)
                }
              }
              .pickerStyle(MenuPickerStyle())
              .padding([.leading, .bottom, .trailing])
            }
            Toggle(isOn: $textDegress) {
              Text(textDegress ? "縦書き" : "横書き")
                .padding(.trailing)
            }.padding([.leading, .bottom, .trailing])

            Button(action: {
              if selectedFont == "P"{
                isShowAlert = true
              }else if textSize == 9{
                isShowAlert = true
              }else{
                showSecondView = true
              }
            }){Text("清書画面へ　　　　　　　　")}
                .bold()
                .padding()
                .frame(width: 250, height: 50)
                .foregroundColor(Color.white)
                .background(Color.black)
                .cornerRadius(10)
            }.padding(.vertical)
            .navigationBarTitle("入力画面", displayMode: .inline)
            .alert("Error", isPresented: $isShowAlert) {
              // ダイアログ内で行うアクション処理...
              Button("戻る"){}
              Button("無料トライアルを始める"){showSubscription = true}
                .sheet(isPresented: $showSubscription){
                  SubscriptionView(subscriptionFlag: $subscriptionFlag)
                    .environmentObject(entitlementManager)
                    .environmentObject(purchaseManager)
                    .task {
                      await purchaseManager.updatePurchasedProducts()
                    }
                }
          } message: {
              // アラートのメッセージ...
              Text("選択されたフォント/大きさは使用できません")
          }
            .fullScreenCover(isPresented: $showSecondView) {
              SecondView(
                text: inputText,font: selectedFont,degress: textDegress, size: textSize, isPresented: $showSecondView, subscriptionFlag: $subscriptionFlag, entitlementManager: entitlementManager, purchaseManager: purchaseManager
              )
            }
        }
    }
}

struct SecondView: View {
    let text: String
    let font: String
    let degress: Bool
    let size: Int
    @Binding var isPresented: Bool
    @State private var textPosition: CGSize = .zero
    @State private var isLocked: Bool = false
    @State private var textScale: CGFloat = 1
    @Environment(\.displayScale) private var displayScale
    @State private var showSavePhotoAlert = false
    @State private var showKeepDataAlert = false
    @State private var showingAlert = false
    @State private var showSubscription2 = false
    @Binding var subscriptionFlag: Bool
  // 文字間隔を計算する関数
  private func calculateSpacing() -> CGFloat {
      switch size {
      case 48: return 0.1
      case 60: return 0.125
      case 72: return 0.15
      case 84: return 0.175
      case 96: return 0.2
      case 108: return 0.225
      default: return 0.25
      }
  }
    @State private var magnifyBy = 1.0
    var magnification: some Gesture {
      MagnificationGesture()
          .onChanged { value in
              magnifyBy = value
          }
  }

  private func sampleView() -> some View {
    HStack {
        Spacer()
      if degress == true {
        VStack(spacing: calculateSpacing()) {
          ForEach(Array(text), id: \.self){ char in
            Text(String(char))
              .font(Font.custom(font, size: CGFloat(size)))
              .offset(textPosition)
              .scaleEffect(textScale)
          }
        }
      }
      else{
        Text(text)
        .font(Font.custom(font, size: CGFloat(size)))
        .rotationEffect(.degrees(90))
        .padding()
        .kerning(10)
        .offset(textPosition)
        .scaleEffect(textScale)
      }
        Spacer()
    }.frame(width: 400.0, height: 800.0) //HStack
  } //View

  @MainActor
  func render() -> UIImage? {
      let renderer = ImageRenderer(content: sampleView())
      renderer.scale = displayScale
      return renderer.uiImage
  }
  @StateObject private var iapManager = IAPManager.shared
  let entitlementManager: EntitlementManager
  @ObservedObject var purchaseManager: PurchaseManager
  @ObservedObject var subscriptionState = SubscriptionState()

    var body: some View {
        VStack {
          HStack {
            VStack{
              Button(action: {
                isLocked.toggle()
              }) {
                Image(systemName: isLocked ? "lock.fill" : "lock.open.fill")
                  .foregroundColor(.black)
                  .imageScale(.large)
                  .padding()
                  .overlay(
                    Circle()
                      .stroke(Color.black, lineWidth: 3)
                  )
              }
              .padding()
              Button(action: {
                textPosition = .zero
              }) {
                Image(systemName: "arrow.counterclockwise")
                  .foregroundColor(.black)
                  .imageScale(.large)
                  .padding()
                  .overlay(
                    Circle()
                      .stroke(Color.black, lineWidth: 3)
                  )
              }
            }
            Spacer()
            VStack{
            Button(action: {
              isPresented = false
            }) {
              Image(systemName: "xmark")
                .foregroundColor(.black)
                .padding()
                .background(Color(white: 0.9, opacity: 1.0))
                .clipShape(Circle())

            }
            .padding()
              Button(action: {
                textPosition = .zero
                if subscriptionFlag == true {
                  showSavePhotoAlert.toggle()
                    if let image = render() {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }

                }else{
                  showSubscription2 = true
                }
              }) {
                Image(systemName: "square.and.arrow.up")
                  .foregroundColor(.black)
                  .imageScale(.large)
                  .padding()
                  .overlay(
                    Circle()
                      .stroke(Color.black, lineWidth: 3)
                  )
                  .alert(isPresented: $showSavePhotoAlert) {
                    Alert(title: Text("保存完了"), message: Text("画像がカメラロールに保存されました。"), dismissButton: .default(Text("OK")))
                  }
              }
              .sheet(isPresented: $showSubscription2){
                SubscriptionView(subscriptionFlag: $subscriptionFlag)
                  .environmentObject(entitlementManager)
                  .environmentObject(purchaseManager)
                  .task {
                    await purchaseManager.updatePurchasedProducts()
                  }
              }
              .padding()
          }
            }
          ZStack{
            HStack {
              Spacer()
              if degress == true {
                  VStack(spacing: calculateSpacing())
                  {
                      // 文字を一文字ずつ縦に表示
                      ForEach(Array(text.enumerated()), id: \.offset) { _, character in
                          Text(String(character))
                          //.font(.system(size: CGFloat(size)))
                          .font(Font.custom(font, size: CGFloat(size)))
                          .offset(textPosition)
                          .gesture(
                            DragGesture()
                              .onChanged { value in
                                if !isLocked {
                                  textPosition = value.translation
                                }
                              }
                          )

                      }
                  }
                  .padding()
                .offset(textPosition)
                .scaleEffect(magnifyBy)
                .gesture(magnification)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
              }
              else{
                Text(text)
                  .font(Font.custom(font, size: CGFloat(size)))
                  .rotationEffect(.degrees(90))
                  .padding()
                  .kerning(10)
                  .offset(textPosition)
                  .scaleEffect(textScale)
                  .gesture(
                    DragGesture()
                      .onChanged { value in
                        if !isLocked {
                          textPosition = value.translation
                        }
                      }
                  )
                  .gesture(
                    MagnificationGesture()
                      .onChanged { value in
                        if !isLocked {
                          textScale = value
                        }
                      }
                  )
              }
              Spacer()
            }//HStack
          }//ZStack
            Spacer()
        }.frame(
          width: 400.0, height: 800.0
        )
    }
}

#Preview {
    ContentView()
}
