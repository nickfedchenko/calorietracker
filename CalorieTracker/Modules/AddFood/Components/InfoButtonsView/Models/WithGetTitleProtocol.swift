//
//  WithGetTitleProtocol.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.11.2022.
//

import Foundation

protocol WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String?
}

protocol WithGetDescriptionProtocol {
    func getDescription() -> NSAttributedString?
}

struct EmptyGetTitle: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        nil
    }
}

enum Lenght {
    case short
    case long
}
