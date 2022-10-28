//
//  AddFoodViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 28.10.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol AddFoodViewControllerInterface: AnyObject {

}

final class AddFoodViewController: UIViewController {
    var presenter: AddFoodPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension AddFoodViewController: AddFoodViewControllerInterface {

}
