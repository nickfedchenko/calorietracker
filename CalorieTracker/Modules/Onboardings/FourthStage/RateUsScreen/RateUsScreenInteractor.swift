//
//  RateUsScreenInteractor.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Foundation

protocol RateUsScreenInteractorInterface: AnyObject {

}

class RateUsScreenInteractor {
    weak var presenter: RateUsScreenPresenterInterface?
}

extension RateUsScreenInteractor: RateUsScreenInteractorInterface {

}
