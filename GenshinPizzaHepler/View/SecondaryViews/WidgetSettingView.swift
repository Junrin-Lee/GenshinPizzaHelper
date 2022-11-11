//
//  WidgetSettingView.swift
//  GenshinPizzaHepler
//
//  Created by 戴藏龙 on 2022/11/11.
//

import SwiftUI

struct WidgetSettingView: View {
    @AppStorage("mainWidgetRefreshFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var mainWidgetRefreshFrequencyInMinute: Double = 30
    @AppStorage("lockscreenWidgetRefreshFrequencyInMinute", store: UserDefaults(suiteName: "group.GenshinPizzaHelper")) var lockscreenWidgetRefreshFrequencyInMinute: Double = 30

    var body: some View {
        List {
            Section {
                RefreshFrequencySettingBar(title: "主屏幕小组件刷新频率",
                                           value: $mainWidgetRefreshFrequencyInMinute,
                                           bounds: 7...120,
                                           step: 1)
                RefreshFrequencySettingBar(title: "锁定屏幕小组件刷新频率",
                                           value: $lockscreenWidgetRefreshFrequencyInMinute,
                                           bounds: 7...120,
                                           step: 1)
            } header: {
                Text("小组件刷新频率")
            }
        }
        .navigationBarTitle("小组件设置", displayMode: .inline)
    }
}

private struct RefreshFrequencySettingBar<V>: View where V : BinaryFloatingPoint, V.Stride : BinaryFloatingPoint {
    let title: String
    @Binding var value: Double
    let bounds: ClosedRange<V>
    let step: V.Stride

    @State var showSlider: Bool = false

    var body: some View {
        HStack {
            Text(title.localized)
            Spacer()
            Button(action: {
                withAnimation{ showSlider.toggle() }
            }) {
                Text(String(format: NSLocalizedString("每%lld分钟", comment: ""), Int(value)))
            }
        }
        if showSlider {
            Slider(value: $value,
                   in: 7...120,
                   step: 1,
                   label: {Text("\(value)")})
        }

    }
}

