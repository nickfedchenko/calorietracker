//
//  GetStartedViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

final class GetStartedViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let getStartedView: GetStartedView = .init()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        view = getStartedView
    }
}
