//
//  UserSex+.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.12.2022.
//

import UIKit

extension UserSex: WithGetTitleProtocol {
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .male:
            return "male".localized
        case .famale:
            return "famale".localized
        }
    }
}

extension UserSex: WithGetImageProtocol, WithGetDescriptionProtocol {
    func getImage() -> UIImage? {
        return nil
    }
    
    func getDescription() -> NSAttributedString? {
        return nil
    }
}
