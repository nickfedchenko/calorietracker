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

struct EmptyGetTitle: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        nil
    }
}

enum Lenght {
    case short
    case long
}
