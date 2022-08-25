//
//  StageCounterView.swift
//  CalorieTracker
//
//  Created by Алексей on 22.08.2022.
//

import UIKit

final class StageCounterView: UIView {
    
    // MARK: - Public properties
    
    override var intrinsicContentSize: CGSize { CGSize(width: 212, height: 30) }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
