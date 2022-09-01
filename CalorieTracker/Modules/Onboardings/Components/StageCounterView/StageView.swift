//
//  StageView.swift
//  CalorieTracker
//
//  Created by Алексей on 01.09.2022.
//

import Foundation
import UIKit

final class StageView: UIView {
    
    // MARK: - Style
    
    enum Style {
        case active
        case inactive
        case completed
    }
    
    // MARK: - Views properties

    private let circleView: UIView = .init()
    private let checkMarkImageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    
    // MARK: - Public properties
    
    var style: Style = .inactive {
        didSet { didChangedStyle() }
    }
    
    // MARK: - Private properties
    
    init(stage: Int) {
        super.init(frame: .zero)
        
        titleLabel.text = String(stage)
        
        configureViews()
        configureLayouts()
        didChangedStyle()
    }
    
    private func configureViews() {
        circleView.layer.borderColor = R.color.onboardings.radialGradientFirst()?.cgColor

        checkMarkImageView.image = R.image.onboardings.whitCheckMark()
        
        titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        titleLabel.textColor = .white
    }
    
    private func configureLayouts() {
        addSubview(circleView)
        
        circleView.addSubview(checkMarkImageView)
        circleView.addSubview(titleLabel)
        
        snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        circleView.snp.makeConstraints {
            $0.edges.equalTo(snp.edges).inset(0)
        }
        
        checkMarkImageView.snp.makeConstraints {
            $0.centerY.equalTo(circleView.snp.centerY)
            $0.centerX.equalTo(circleView.snp.centerX)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(circleView.snp.centerY)
            $0.centerX.equalTo(circleView.snp.centerX)
        }
    }
    
    private func didChangedStyle() {
        switch style {
        case .active:
            titleLabel.isHidden = false
            checkMarkImageView.isHidden = true
            circleView.layer.cornerRadius = 15
            circleView.backgroundColor = R.color.onboardings.radialGradientFirst()
            circleView.layer.borderWidth = 0
            snp.updateConstraints {
                $0.size.equalTo(30)
            }
        case .inactive:
            titleLabel.isHidden = true
            checkMarkImageView.isHidden = true
            circleView.layer.cornerRadius = 11
            circleView.backgroundColor = .white
            circleView.layer.borderWidth = 2
            snp.updateConstraints {
                $0.size.equalTo(22)
            }
        case .completed:
            checkMarkImageView.isHidden = false
            titleLabel.isHidden = true
            circleView.layer.cornerRadius = 15
            circleView.backgroundColor = R.color.onboardings.radialGradientFirst()
            circleView.layer.borderWidth = 0
            snp.updateConstraints {
                $0.size.equalTo(30)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
