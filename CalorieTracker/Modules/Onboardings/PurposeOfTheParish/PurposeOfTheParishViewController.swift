//
//  PurposeOfTheParishViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import UIKit

final class PurposeOfTheParishViewController: UIViewController {
    // MARK: - Private properties
    
    private let purposeOfTheParishView: PurposeOfTheParishView = .init()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        view = purposeOfTheParishView
    }
}
