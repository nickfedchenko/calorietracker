//
//  ChartFormat.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 31.08.2022.
//

import Foundation

enum ChartFormat: String {
    case daily
    case weekly
    case monthly
    
    var title: String {
        switch self {
        case .daily:
            return "day".localized
        case .weekly:
            return "week".localized
        case .monthly:
            return R.string.localizable.weightWidgetFullSegmentMonth().lowercased()
        }
    }
}
