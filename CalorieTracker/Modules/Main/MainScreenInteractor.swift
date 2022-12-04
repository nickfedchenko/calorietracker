//
//  MainScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import Foundation

protocol MainScreenInteractorInterface: AnyObject {

}

class MainScreenInteractor {
    weak var presenter: MainScreenPresenterInterface?
}

extension MainScreenInteractor: MainScreenInteractorInterface {

}
