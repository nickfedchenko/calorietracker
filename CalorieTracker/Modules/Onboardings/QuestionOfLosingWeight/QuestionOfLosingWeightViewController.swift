//
//  QuestionOfLosingWeightViewController.swift
//  CalorieTracker
//
//  Created by Алексей on 20.08.2022.
//

import Foundation
import UIKit

final class QuestionOfLosingWeightViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let questionOfLosingWeightView: QuestionOfLosingWeightView = .init()
    
    // MARK: - Lifecycle methods
    
    override func loadView() {
        super.loadView()
        
        view = questionOfLosingWeightView
    }
}
