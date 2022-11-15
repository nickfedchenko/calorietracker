//
//  FoodViewingViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol FoodViewingViewControllerInterface: AnyObject {

}

class FoodViewingViewController: UIViewController {
    var presenter: FoodViewingPresenterInterface?
}

extension FoodViewingViewController: FoodViewingViewControllerInterface {

}
