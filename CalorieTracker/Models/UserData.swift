//
//  UserData.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.12.2022.
//

import Foundation

struct UserData: Codable {
    let name: String
    let lastName: String?
    let city: String?
    let sex: UserSex
    let dateOfBirth: Date
    let height: Double
    let dietary: UserDietary
}

enum UserSex: String, Codable {
    case male
    case famale
}

enum UserDietary: Codable {
    case classic
    case pescatarian
    case vegetarian
    case vegan
}
