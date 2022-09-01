//
//  StageCounterView.swift
//  CalorieTracker
//
//  Created by Алексей on 01.09.2022.
//

import UIKit

final class StageCounterView: UIView {
    
    // MARK: - Views properties
    
    private let stackView: UIStackView = .init()
    private let firstStageView: StageView = .init(stage: 1)
    private let firstStageProgressBar: StageProgressBarView = .init()
    private let secondStageView: StageView = .init(stage: 2)
    private let secondStageProgressBar: StageProgressBarView = .init()
    private let thirdStageView: StageView = .init(stage: 3)
    private let thirdStageProgressBar: StageProgressBarView = .init()
    private let fourhtStageView: StageView = .init(stage: 4)

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        configureLayouts()
    }
    
    private func configureViews() {
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        
        firstStageView.style = .completed
        firstStageProgressBar.progress = 0.0
        secondStageProgressBar.progress = 0.0
        thirdStageProgressBar.progress = 0.0
    }
    
    private func configureLayouts() {
        addSubview(stackView)
        
        stackView.addArrangedSubview(firstStageView)
        stackView.addArrangedSubview(firstStageProgressBar)
        stackView.addArrangedSubview(secondStageView)
        stackView.addArrangedSubview(secondStageProgressBar)
        stackView.addArrangedSubview(thirdStageView)
        stackView.addArrangedSubview(thirdStageProgressBar)
        stackView.addArrangedSubview(fourhtStageView)
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(snp.top)
            $0.left.equalTo(snp.left)
            $0.right.equalTo(snp.right)
            $0.bottom.equalTo(snp.bottom)
        }
        
        firstStageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        firstStageProgressBar.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(32)
        }
        
        secondStageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        secondStageProgressBar.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(32)
        }
        
        thirdStageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
        
        thirdStageProgressBar.snp.makeConstraints {
            $0.height.equalTo(2)
            $0.width.equalTo(32)
        }
        
        fourhtStageView.snp.makeConstraints {
            $0.size.equalTo(30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StageCounterView {
    func set(onboardingStage: OnboardingStage) {
        switch onboardingStage {
        case .first(let progress):
            firstStageView.style = .active
            secondStageView.style = .inactive
            thirdStageView.style = .inactive
            fourhtStageView.style = .inactive
            
            firstStageProgressBar.progress = progress
            secondStageProgressBar.progress = 0.0
            thirdStageProgressBar.progress = 0.0
        case .second(let progress):
            firstStageView.style = .completed
            secondStageView.style = .active
            thirdStageView.style = .inactive
            fourhtStageView.style = .inactive
            
            firstStageProgressBar.progress = 1.0
            secondStageProgressBar.progress = progress
            thirdStageProgressBar.progress = 0.0
        case .third(let progress):
            firstStageView.style = .completed
            secondStageView.style = .completed
            thirdStageView.style = .active
            fourhtStageView.style = .inactive
            
            firstStageProgressBar.progress = 1.0
            secondStageProgressBar.progress = 1.0
            thirdStageProgressBar.progress = progress
        case .fourth:
            firstStageView.style = .completed
            secondStageView.style = .completed
            thirdStageView.style = .completed
            fourhtStageView.style = .active
            
            firstStageProgressBar.progress = 1.0
            secondStageProgressBar.progress = 1.0
            thirdStageProgressBar.progress = 1.0
        }
    }
}
