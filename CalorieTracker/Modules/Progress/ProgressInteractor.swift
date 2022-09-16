//
//  ProgressInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 07.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import Foundation

protocol ProgressInteractorInterface: AnyObject {

}

class ProgressInteractor {
    weak var presenter: ProgressPresenterInterface?
}

extension ProgressInteractor: ProgressInteractorInterface {

}
