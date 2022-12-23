//
//  QuickAddModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.12.2022.
//

import UIKit

struct QuickAddModel: Codable {
    let type: TypeQuickAdd
    let value: Int?
}

enum TypeQuickAdd: Equatable, Codable {
    case add
    case edit
    case cup
    case bottle
    case bottleSport
    case jug
}

extension TypeQuickAdd: WithGetImageProtocol {
    func getImage() -> UIImage? {
        switch self {
        case .add:
            return R.image.quickAdd.add()
        case .cup:
            return R.image.quickAdd.cup()
        case .bottle:
            return R.image.quickAdd.bottle()
        case .bottleSport:
            return R.image.quickAdd.bottleSport()
        case .jug:
            return R.image.quickAdd.jug()
        case .edit:
            return R.image.quickAdd.edit()
        }
    }
}
