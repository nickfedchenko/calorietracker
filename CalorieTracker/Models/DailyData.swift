//
//  DailyData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import CoreData
import Foundation

protocol DomainDailyProtocol: NSManagedObject {
    var day: Int32 { get }
    var month: Int32 { get }
    var year: Int32 { get }
    var value: Double { get }
    var isFromHK: Bool { get }
}

struct DailyData {
    let day: Day
    let value: Double
    let isFromHK: Bool
    
    init(day: Day, value: Double, isFromHK: Bool = false) {
        self.day = day
        self.value = value
        self.isFromHK = isFromHK
    }
    
    init?(from managedModel: DomainDailyProtocol) {
        self.value = managedModel.value
        self.day = .init(
            day: Int(managedModel.day),
            month: Int(managedModel.month),
            year: Int(managedModel.year)
        )
        self.isFromHK = managedModel.isFromHK
    }
}
