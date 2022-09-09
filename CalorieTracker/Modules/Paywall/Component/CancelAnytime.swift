//
//  CancelAnytime.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation
import UIKit

class CancelAnytime: UIButton {
    
    // MARK: - Views properties
    
    private let textLabel: UILabel = .init()
    private let lockImageView: UIImageView = .init()
    
    // MARK: - initialization

    override init(frame: CGRect) {
        super .init(frame: .zero)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        textLabel.text = "Cancel anytime"
        textLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        lockImageView.image = R.image.paywall.lock()
    }
    
    private func configureLayouts() {
        addSubview(lockImageView)
        
        addSubview(textLabel)
        
        lockImageView.snp.makeConstraints {
            $0.left.equalTo(snp.left)
            $0.size.equalTo(15)
            $0.centerY.equalTo(textLabel.snp.centerY)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(lockImageView.snp.right).offset(8)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
