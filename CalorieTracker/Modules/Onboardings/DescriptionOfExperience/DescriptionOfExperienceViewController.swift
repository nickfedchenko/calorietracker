//
//  DescriptionOfExperienceViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit

final class DescriptionOfExperienceViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let descriptionOfExperienceView: DescriptionOfExperienceView = .init()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        view = descriptionOfExperienceView
    }
}
