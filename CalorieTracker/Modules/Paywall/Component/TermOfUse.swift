//
//  TermOfUse.swift
//  CalorieTracker
//
//  Created by Алексей on 08.09.2022.
//

import Foundation
import UIKit

final class TermOfUse: UIButton {
    
    // MARK: - Views properties
    
    private let textLabel: UILabel = .init()
    
    // MARK: - initialization
    
    override init(frame: CGRect) {
        super .init(frame: .zero)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        textLabel.text = "Terms of use"
        textLabel.font = R.font.sfProRoundedMedium(size: 12)
        textLabel.textColor = UIColor(hex: "192621")
    }
    
    private func configureLayouts() {
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
