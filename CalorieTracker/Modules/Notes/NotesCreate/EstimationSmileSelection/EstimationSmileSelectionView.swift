//
//  EstimationSmileSelectionView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

final class EstimationSmileSelectionView: UIView {
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 4
        return stack
    }()
    
    private let estimations: [Estimation] = [
        .verySad,
        .sad,
        .normal,
        .good,
        .veryGood
    ]
    
    var selectedEstimation: Estimation? {
        stackView.arrangedSubviews
            .compactMap { return $0 as? EstimationSmileButton }
            .first(where: { $0.isSelectedSmile })?.type
    }
    
    var didChangeValue: ((Estimation) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStack()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStack() {
        estimations
            .map { return EstimationSmileButton($0) }
            .forEach { button in
                button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
                stackView.addArrangedSubview(button)
            }
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapButton(_ sender: EstimationSmileButton) {
        didChangeValue?(sender.type)
        stackView.arrangedSubviews
            .compactMap { return ($0 as? EstimationSmileButton) }
            .forEach { $0.isSelectedSmile = $0 == sender }
    }
}
