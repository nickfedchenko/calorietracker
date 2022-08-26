//
//  SignInAppleButton.swift
//  CalorieTracker
//
//  Created by Алексей on 19.08.2022.
//

import Foundation
import UIKit

class SignInAppleButton: UIButton {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
    }
    
    private func configureViews() {
        backgroundColor = .clear
        contentHorizontalAlignment = .center
        
        setImage(R.image.onboardings.sigInApple(), for: .normal)
        
        titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        
        setTitle("Sign in with Apple", for: .normal)
        setTitleColor(.black, for: .normal)
        
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
