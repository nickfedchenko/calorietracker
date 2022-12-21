//
//  SettingsInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol SettingsInteractorInterface: AnyObject {

}

class SettingsInteractor {
    weak var presenter: SettingsPresenterInterface?
}

extension SettingsInteractor: SettingsInteractorInterface {

}
