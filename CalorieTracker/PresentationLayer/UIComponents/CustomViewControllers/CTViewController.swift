//
//  CTViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.01.2023.
//

import UIKit

class CTViewController: UIViewController {
    var callViewWillAppear: Bool = true
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard callViewWillAppear else { return }
        presentingViewController?.viewWillAppear(false)
    }
}
