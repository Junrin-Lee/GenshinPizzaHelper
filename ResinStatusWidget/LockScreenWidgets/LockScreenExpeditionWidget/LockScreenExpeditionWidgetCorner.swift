//
//  LockScreenHomeCoinWidgetCorner.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/9/12.
//

import SwiftUI

@available(iOSApplicationExtension 16.0, *)
struct LockScreenExpeditionWidgetCorner: View {
    @Environment(\.widgetRenderingMode) var widgetRenderingMode

    let result: FetchResult

    var text: String {
        switch result {
        case .success(let data):
            return "\(data.expeditionInfo.currentOngoingTask)/\(data.expeditionInfo.maxExpedition) \(data.expeditionInfo.nextCompleteTimeIgnoreFinished.describeIntervalLong(finishedTextPlaceholder: "已完成"))"
        case .failure(_):
            return ""
        }
    }

    var body: some View {
        Image("icon.expedition")
            .resizable()
            .scaledToFit()
            .padding(4.5)
            .widgetLabel(text)
    }
}