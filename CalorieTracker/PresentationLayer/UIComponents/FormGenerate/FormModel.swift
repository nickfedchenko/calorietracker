//
//  FormModel.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import Foundation

struct FormModel<T: WithGetTitleProtocol> {
    let type: T
    let width: FormWidth
    let value: FormValue
}

extension FormModel where T == EmptyGetTitle {
    init(width: FormWidth, value: FormValue) {
        self.init(type: .init(), width: width, value: value)
    }
}

enum FormValue: WithGetTitleProtocol {
    case optional
    case required(String?)
    
    func getTitle(_ lenght: Lenght) -> String? {
        switch self {
        case .optional:
            return R.string.localizable.textFieldOptional().capitalized
        case .required(let placeholder):
            return placeholder ?? R.string.localizable.textFieldRequired().capitalized
        }
    }
}

enum FormWidth: Double {
    case large = 1.0
    case small = 0.957
}
