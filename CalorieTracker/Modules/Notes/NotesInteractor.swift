//
//  NotesInteractor.swift
//  CIViperGenerator
//
//  Created by Mov4D on 04.01.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import Foundation

protocol NotesInteractorInterface: AnyObject {

}

class NotesInteractor {
    weak var presenter: NotesPresenterInterface?
}

extension NotesInteractor: NotesInteractorInterface {

}
