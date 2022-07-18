//
//  MainScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol MainScreenViewControllerInterface: AnyObject {

}

class MainScreenViewController: UIViewController {
    var presenter: MainScreenPresenterInterface?
}

extension MainScreenViewController: MainScreenViewControllerInterface {

}
