//
//  WelcomeViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

final class WelcomeViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let welcomView: WelcomeView = .init()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        view = welcomView
    }
}
