//
//  WidgetData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 14.09.2022.
//

import Foundation

struct WidgetData: Codable {
    let date: Date
    let value: Double
}

struct DoubleWidgetData: Codable {
    let date: Date
    let valueFirst: Double
    let valueSecond: Double
}

struct TripleWidgetData: Codable {
    let date: Date
    let valueFirst: Double
    let valueSecond: Double
    let valueThird: Double
}
