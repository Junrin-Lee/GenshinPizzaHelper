//
//  DisplayOptionsView.swift
//  GenshinPizzaHepler
//
//  Created by ShikiSuen on 2023/3/29.
//  界面偏好设置页面。

import Combine
import HBMihoyoAPI
import SwiftUI

// MARK: - DisplayOptionsView

struct DisplayOptionsView: View {
    // MARK: Public

    @AppStorage(
        "useGuestGachaEvaluator",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    public var useGuestGachaEvaluator: Bool = false

    // MARK: Internal

    var body: some View {
        Group {
            mainView()
                .alert("请输入自定义流浪者姓名", isPresented: $isCustomizedNameForWandererAlertShow, actions: {
                    TextField("自定义姓名", text: $customizedNameForWanderer)
                        .onReceive(Just(customizedNameForWanderer)) { _ in limitText(20) }
                    Button("完成") {
                        isCustomizedNameForWandererAlertShow.toggle()
                    }
                })
        }
        .navigationBarTitle("界面偏好设置", displayMode: .inline)
    }

    // Function to keep text length in limits
    func limitText(_ upper: Int) {
        if customizedNameForWanderer.count > upper {
            customizedNameForWanderer = String(customizedNameForWanderer.prefix(upper))
        }
    }

    @ViewBuilder
    func mainView() -> some View {
        List {
            if Locale.isUILanguagePanChinese {
                Section {
                    Toggle(isOn: $forceCharacterWeaponNameFixed) {
                        Text("中文汉字纠正")
                    }
                } footer: {
                    Text(
                        "这将会在简体中文当中强制自动恢复目前已被当地语委恢复的「锺」、在繁体中文当中强制自动恢复「堇」的当代繁体中文写法「菫」。"
                    )
                }
            }

            Section {
                Toggle(isOn: $showRarityAndLevelForArtifacts) {
                    Text("显示圣遗物等级与稀有度")
                }
                Toggle(isOn: $showRatingsForArtifacts) {
                    Text("显示圣遗物评分与评价")
                }
            }

            Section {
                Toggle(isOn: $useActualCharacterNames) {
                    Text("显示部分角色的真实姓名")
                }

                if !useActualCharacterNames {
                    if #unavailable(iOS 16) {
                        HStack {
                            Text("自定义流浪者姓名")
                            Spacer()
                            TextField("流浪者".localized, text: $customizedNameForWanderer)
                                .multilineTextAlignment(.trailing)
                        }
                    } else {
                        HStack {
                            Text("自定义流浪者姓名")
                            Spacer()
                            Button(customizedNameForWanderer == "" ? "流浪者".localized : customizedNameForWanderer) {
                                isCustomizedNameForWandererAlertShow.toggle()
                            }
                        }
                    }
                }
            }

            if ThisDevice.notchType != .none || OS.type != .iPhoneOS {
                Section {
                    Toggle(isOn: $adaptiveSpacingInCharacterView) {
                        Text("角色详情排版间距适配")
                    }
                } footer: {
                    Text(
                        "这仅对 iPad 以及有「刘海」的 iPhone 生效。"
                    )
                }
            }

            Section {
                Toggle(isOn: $cutShouldersForSmallAvatarPhotos) {
                    Text("裁掉小尺寸角色照片当中的肩膀")
                }
            }

            Section {
                Toggle(isOn: $useGuestGachaEvaluator) {
                    Text("setting.uirelated.useguestgachaevaluator")
                }
            }
        }
    }

    // MARK: Private

    @State
    private var isCustomizedNameForWandererAlertShow: Bool = false

    @AppStorage(
        "adaptiveSpacingInCharacterView",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    private var adaptiveSpacingInCharacterView: Bool = true

    @AppStorage(
        "showRarityAndLevelForArtifacts",
        store: UserDefaults(suiteName: "group.GenshinPizzaHelper")
    )
    private var showRarityAndLevelForArtifacts: Bool = true

    @AppStorage(
        "showRatingsForArtifacts",
        store: UserDefaults(suiteName: "group.GenshinPizzaHelper")
    )
    private var showRatingsForArtifacts: Bool = true

    @ObservedObject
    private var viewModel: MoreViewCacheViewModel = .init()

    @AppStorage(
        "forceCharacterWeaponNameFixed",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    private var forceCharacterWeaponNameFixed: Bool = false
    @AppStorage(
        "useActualCharacterNames",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    private var useActualCharacterNames: Bool = false

    @AppStorage(
        "customizedNameForWanderer",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    private var customizedNameForWanderer: String = ""

    @AppStorage(
        "cutShouldersForSmallAvatarPhotos",
        store: .init(suiteName: "group.GenshinPizzaHelper")
    )
    private var cutShouldersForSmallAvatarPhotos: Bool = false
}
