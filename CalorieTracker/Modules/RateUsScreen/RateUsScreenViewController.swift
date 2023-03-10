//
//  RateUsScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol RateUsScreenViewControllerInterface: AnyObject {

}

class RateUsScreenViewController: UIViewController {
    var presenter: RateUsScreenPresenterInterface?
}

extension RateUsScreenViewController: RateUsScreenViewControllerInterface {

}
