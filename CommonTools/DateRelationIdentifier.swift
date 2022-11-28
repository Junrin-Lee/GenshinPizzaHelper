//
//  DateRelationIdentifier.swift
//  GenshinPizzaHelper
//
//  Created by 戴藏龙 on 2022/11/26.
//

import Foundation

enum DateRelationIdentifier {
    case today
    case tomorrow
    case other

    static func getRelationIdentifier(of date: Date, from benchmarkDate: Date = Date()) -> Self {
        let dayDiffer = Calendar.current.component(.day, from: date) - Calendar.current.component(.day, from: benchmarkDate)
        switch dayDiffer {
        case 0: return .today
        case 1: return .tomorrow
        default: return .other
        }
    }
}

extension Date {
    func getRelativeDateString(benchmarkDate: Date = Date()) -> String {
        let relationIdentifier: DateRelationIdentifier = .getRelationIdentifier(of: self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "H:mm"
        let datePrefix: String
        switch relationIdentifier {
        case .today:
            datePrefix = ""
        case .tomorrow:
            datePrefix = "明天 "
        case .other:
            datePrefix = ""
            formatter.dateFormat = "EEE H:mm"
        }
        return datePrefix.localized + formatter.string(from: self)
    }
}
