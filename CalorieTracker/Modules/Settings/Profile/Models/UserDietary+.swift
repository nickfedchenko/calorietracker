//
//  UserDietary+.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import Foundation

extension UserDietary: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .classic:
            return "Classic"
        case .pescatarian:
            return "Pescatarian"
        case .vegetarian:
            return "Vegetarian"
        case .vegan:
            return "Vegan"
        }
    }
}
