//
//  SearchFoodViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 23.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol SearchFoodViewControllerInterface: AnyObject {

}

class SearchFoodViewController: UIViewController {
    var presenter: SearchFoodPresenterInterface?
}

extension SearchFoodViewController: SearchFoodViewControllerInterface {

}
