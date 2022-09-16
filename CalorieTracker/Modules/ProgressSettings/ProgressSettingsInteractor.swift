//
//  ProgressSettingsInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 12.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProgressSettingsInteractorInterface: AnyObject {

}

class ProgressSettingsInteractor {
    weak var presenter: ProgressSettingsPresenterInterface?
}

extension ProgressSettingsInteractor: ProgressSettingsInteractorInterface {

}
