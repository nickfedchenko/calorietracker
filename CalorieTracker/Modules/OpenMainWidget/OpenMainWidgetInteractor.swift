//
//  OpenMainWidgetInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import Foundation

protocol OpenMainWidgetInteractorInterface: AnyObject {

}

class OpenMainWidgetInteractor {
    weak var presenter: OpenMainWidgetPresenterInterface?
}

extension OpenMainWidgetInteractor: OpenMainWidgetInteractorInterface {

}
