//
//  Note.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 04.01.2023.
//

import Foundation

struct Note {
    let id: String
    let date: Date
    let text: String
    let estimation: Estimation
    let imageUrl: URL?
}

extension Note {
    init?(from managedModel: DomainNote) {
        self.id = managedModel.id
        self.date = managedModel.date
        self.estimation = Estimation(rawValue: Int(managedModel.estimation)) ?? .normal
        self.text = managedModel.text
        self.imageUrl = managedModel.imageUrl
    }
}
