//
//  ColorHandler.swift
//  GenshinPizzaHelper
//
//  Created by Bill Haku on 2022/8/12.
//  Widget和App内的背景支持

import Foundation
import SwiftUI

// MARK: - BackgroundOptions

struct BackgroundOptions {
    static let colors: [String] = [
        "★灰",
        "★★绿",
        "★★★蓝",
        "★★★★紫",
        "★★★★★金",
        "★★★★★红",
        "风元素",
        "水元素",
        "冰元素",
        "火元素",
        "岩元素",
        "雷元素",
        "草元素",
        "纠缠之缘",
    ]
    static let elements: [String] = [
        "风元素",
        "水元素",
        "冰元素",
        "火元素",
        "岩元素",
        "雷元素",
        "草元素",
    ]
    static let namecards: [String] = NameCard.allCases.map(\.rawValue)

    static let allOptions: [(String, String)] = BackgroundOptions.colors.map { ($0, $0) } + NameCard.allCases
        .map { ($0.rawValue, $0.localized) }

    static let elementsAndNamecard: [(String, String)] = BackgroundOptions.elements.map { ($0, $0) } + NameCard.allCases
        .map { ($0.rawValue, $0.localized) }
}

extension WidgetBackground {
    static let defaultBackground: WidgetBackground = .init(
        identifier: NameCard.UI_NameCardPic_Bp20_P.rawValue,
        display: NameCard.UI_NameCardPic_Bp20_P.localized
    )
    static var randomBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.allOptions.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId.0,
            display: pickedBackgroundId.1
        )
    }

    static var randomColorBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.colors.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }

    static var randomNamecardBackground: WidgetBackground {
        let pickedBackgroundId = NameCard.allCases.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId.rawValue,
            display: pickedBackgroundId.localized
        )
    }

    static var randomElementBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.elements.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId,
            display: pickedBackgroundId
        )
    }

    static var randomElementOrNamecardBackground: WidgetBackground {
        let pickedBackgroundId = BackgroundOptions.elementsAndNamecard.randomElement()!
        return WidgetBackground(
            identifier: pickedBackgroundId.0,
            display: pickedBackgroundId.1
        )
    }
}
