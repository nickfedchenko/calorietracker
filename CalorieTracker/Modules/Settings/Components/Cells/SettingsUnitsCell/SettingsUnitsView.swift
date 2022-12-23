//
//  SettingsUnitsView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.12.2022.
//

import UIKit

final class SettingsUnitsView: UIView {
    
    var didChangeUnits: ((Units) -> Void)?
    var viewModel: SettingsUnitsCellViewModel? {
        didSet {
            didSetViewModel()
        }
    }
    
    private lazy var titleLabel: UILabel = getTitleLabel()
    private var segmentedControl: SegmentedControl<Units>?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didSetViewModel() {
        segmentedControl = getSegmentedControl()
        setupConstraints()
        
        segmentedControl?.selectedButtonType = viewModel?.unit
        titleLabel.text = viewModel?.title
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        guard let segmentedControl = segmentedControl else { return }

        addSubviews(
            titleLabel,
            segmentedControl
        )
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.bottom.top.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.65)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
        }
    }
}

// MARK: - Factory

extension SettingsUnitsView {
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = R.color.foodViewing.basicDark()
        label.font = R.font.sfProTextMedium(size: 17.fontScale())
        return label
    }
    
    private func getSegmentedControl() -> SegmentedControl<Units> {
        let segmentedControl: SegmentedControl<Units> = .init([
            .init(
                title: viewModel?.metricTitle ?? "",
                normalColor: R.color.foodViewing.basicGrey(),
                selectedColor: R.color.foodViewing.basicPrimary(),
                id: .metric
            ),
            .init(
                title: viewModel?.imperialTitle ?? "",
                normalColor: R.color.foodViewing.basicGrey(),
                selectedColor: R.color.foodViewing.basicPrimary(),
                id: .imperial
            )
        ])
        segmentedControl.backgroundColor = R.color.settings.segmentedControl()
        segmentedControl.distribution = .fillEqually
        segmentedControl.insets = .init(top: 2, left: 2, bottom: 2, right: 2)
        segmentedControl.selectorRadius = 14
        segmentedControl.layer.cornerRadius = 16
        
        segmentedControl.onSegmentChanged = { model in
            self.didChangeUnits?(model.id)
        }
        
        return segmentedControl
    }
}
