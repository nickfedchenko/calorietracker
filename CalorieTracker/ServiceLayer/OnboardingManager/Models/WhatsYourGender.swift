//
//  WhatsYourGender.swift
//  CalorieTracker
//
//  Created by Алексей on 25.08.2022.
//

enum WhatsYourGender: CaseIterable {
    case male
    case female
}

extension WhatsYourGender {
    var userSex: UserSex {
        switch self {
        case .male:
            return .male
        case .female:
            return .famale
        }
    }
}
