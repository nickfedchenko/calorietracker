//
//  CTRecipesScreenSelector.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.08.2022.
//

import UIKit

final class CTRecipesScreenSelector: UIView {
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Recipes", at: 0, animated: false)
        control.insertSegment(withTitle: "My meals", at: 1, animated: false)
        control.insertSegment(withTitle: "My food", at: 2, animated: false)
        control.backgroundColor = UIColor(hex: "E2FBF4")
        control.selectedSegmentTintColor = .white
        control.setTitleTextAttributes(
            [
                .foregroundColor: UIColor(hex: "0C695E"),
                .font: R.font.sfProRoundedBold(size: 18) ?? .systemFont(ofSize: 18)
            ],
            for: .selected
        )
        control.setTitleTextAttributes(
            [
                .foregroundColor: UIColor(hex: "7A948F"),
                .font: R.font.sfProRoundedBold(size: 18) ?? .systemFont(ofSize: 18)
            ],
            for: .normal
        )
        control.selectedSegmentIndex = 0
        control.setDividerImage(
            UIImage(),
            forLeftSegmentState: .selected,
            rightSegmentState: .selected,
            barMetrics: .default
        )
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(segmentControl)
        segmentControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(48)
            make.bottom.equalToSuperview()
        }
    }
}
