//
//  CommonButton.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

class CommonButton: UIButton {
    
    // MARK: - Style
    
    enum Style {
        case filled
        case bordered
    }
    
    // MARK: - Private properties
    
    private let style: Style
        
    // MARK: - Initialization
    
    init(style: Style, text: String) {
        self.style = style
        
        super.init(frame: .zero)
        
        setTitle(text, for: .normal)
        
        configureViews()
    }
    
    private func configureViews() {
        layer.cornerRadius = 16
        
        titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        
        switch style {
        case .filled:
            backgroundColor = R.color.onboardings.radialGradientFirst()
            setTitleColor(.white, for: .normal)
        case .bordered:
            backgroundColor = .clear
            setTitleColor(R.color.onboardings.borders(), for: .normal)
            layer.borderColor = UIColor(named: R.color.onboardings.borders.name)?.cgColor
            layer.borderWidth = 2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
