//
//  FormModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import Foundation

struct FormModel {
    let type: WithGetTitleProtocol?
    let width: FormWidth
    let value: FormValue
}

enum FormValue: WithGetTitleProtocol {
    case optional
    case required(String?)
    
    func getTitle(_ lenght: Lenght) -> String {
        switch self {
        case .optional:
            return "Optional"
        case .required(let placeholder):
            return placeholder ?? "Required"
        }
    }
}

enum FormWidth: Double {
    case large = 1.0
    case small = 0.957
}
