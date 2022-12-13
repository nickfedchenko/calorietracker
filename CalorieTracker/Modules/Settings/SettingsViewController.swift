//
//  SettingsViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 14.12.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol SettingsViewControllerInterface: AnyObject {

}

final class SettingsViewController: UIViewController {
    var presenter: SettingsPresenterInterface?
}

extension SettingsViewController: SettingsViewControllerInterface {

}
