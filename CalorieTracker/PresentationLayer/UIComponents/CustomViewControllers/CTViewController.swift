//
//  CTViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.01.2023.
//

import UIKit

class CTViewController: UIViewController {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        presentingViewController?.viewWillAppear(false)
    }
}
