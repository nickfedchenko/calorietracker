//
//  DailyData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.12.2022.
//

import Foundation
import CoreData

protocol DomainDailyProtocol: NSManagedObject {
    var day: Int32 { get }
    var month: Int32 { get }
    var year: Int32 { get }
    var value: Double { get }
}

struct DailyData {
    let day: Day
    let value: Double
    
    init(day: Day, value: Double) {
        self.day = day
        self.value = value
    }
    
    init?(from managedModel: DomainDailyProtocol) {
        self.value = managedModel.value
        self.day = .init(
            day: Int(managedModel.day),
            month: Int(managedModel.month),
            year: Int(managedModel.year)
        )
    }
}
