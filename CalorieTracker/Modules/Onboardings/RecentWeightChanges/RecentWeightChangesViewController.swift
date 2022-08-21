//
//  RecentWeightChangesViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 21.08.2022.
//

import Foundation
import UIKit

final class RecentWeightChangesViewController: UIViewController {
    // MARK: - Private properties
    
    private let recentWeightChangesView: RecentWeightChangesView = .init()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        view = recentWeightChangesView
    }
}
