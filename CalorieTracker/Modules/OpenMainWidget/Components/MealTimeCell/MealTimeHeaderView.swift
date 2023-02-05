//
//  MealTimeHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.02.2023.
//

import UIKit

final class MealTimeHeaderView: UIView {
    private lazy var mealTimeImageView: UIImageView = getMealTimeImageView()
    private lazy var mealTimeLabel: UILabel = getMealTimeLabel()
    private lazy var burnKcalImageView: UIImageView = getBurnKcalImageView()
    private lazy var burnKcalLabel: UILabel = getBurnKcalLabel()
    private lazy var addButton: UIButton = getAddButton()
    private lazy var carbsLabel: UILabel = getCarbsLabel()
    private lazy var fatLabel: UILabel = getFatLabel()
    private lazy var proteinLabel: UILabel = getProteinLabel()
    private lazy var leftBottomChevron: UIImageView = getLeftBottomChevron()
    private lazy var rightBottomChevron: UIImageView = getRightBottomChevron()
    
    var viewModel: MealTimeHeaderViewModel? {
        didSet {
            didChangeViewModel()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func didChangeViewModel() {
        guard let viewModel = viewModel else { return }
        mealTimeImageView.image = viewModel.mealTime.getImage()
        mealTimeLabel.text = viewModel.mealTime.getTitle(.long)
        burnKcalLabel.text = "\(viewModel.burnKcal)"
        
        switch viewModel.mealTime {
        case .breakfast:
            leftBottomChevron.tintColor = R.color.openMainWidget.breakfast()
        case .launch:
            leftBottomChevron.tintColor = R.color.openMainWidget.lunch()
        case .dinner:
            leftBottomChevron.tintColor = R.color.openMainWidget.dinner()
        case .snack:
            leftBottomChevron.tintColor = R.color.openMainWidget.snack()
        }
    }
    
    private func setupView() {
        
    }
    
    private func setupConstraints() {
        let stack: UIStackView = {
            let view = UIStackView()
            view.spacing = 16
            view.axis = .horizontal
            return view
        }()
        
        addSubviews(
            mealTimeImageView,
            mealTimeLabel,
            burnKcalImageView,
            burnKcalLabel,
            stack,
            addButton,
            leftBottomChevron,
            rightBottomChevron
        )
        
        stack.addSubviews(
            carbsLabel,
            proteinLabel,
            fatLabel
        )
        
        mealTimeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
        }
        
        mealTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(mealTimeImageView.snp.trailing).offset(8)
            make.centerY.equalTo(mealTimeImageView)
            make.trailing.lessThanOrEqualTo(burnKcalImageView.snp.leading)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-11)
            make.centerY.equalTo(mealTimeImageView)
            make.top.greaterThanOrEqualToSuperview()
            make.width.height.equalTo(34)
        }
        
        burnKcalLabel.snp.makeConstraints { make in
            make.trailing.equalTo(addButton.snp.leading).offset(-15)
            make.centerY.equalTo(mealTimeImageView)
        }
        
        burnKcalImageView.snp.makeConstraints { make in
            make.trailing.equalTo(burnKcalLabel.snp.leading)
            make.height.width.equalTo(24)
            make.centerY.equalTo(burnKcalLabel)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(mealTimeImageView.snp.bottom).offset(5.5)
            make.bottom.equalToSuperview().offset(-11.5)
            make.leading.equalTo(mealTimeLabel.snp.leading)
            make.trailing.lessThanOrEqualToSuperview()
        }
    }
}

// MARK: - Factory

extension MealTimeHeaderView {
    private func getMealTimeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }
    
    private func getMealTimeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = R.color.openMainWidget.dark()
        label.font = R.font.sfProRoundedSemibold(size: 18)
        return label
    }
    
    private func getBurnKcalImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = R.image.openMainWidget.burn()
        return view
    }
    
    private func getBurnKcalLabel() -> UILabel {
        let label = UILabel()
        label.textColor = R.color.openMainWidget.dark()
        label.font = R.font.sfProRoundedSemibold(size: 18)
        return label
    }
    
    private func getAddButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerCurve = .circular
        button.setImage(R.image.openMainWidget.add(), for: .normal)
        button.backgroundColor = R.color.openMainWidget.background()
        return button
    }
    
    private func getCarbsLabel() -> UILabel {
        return UILabel()
    }
    
    private func getFatLabel() -> UILabel {
        return UILabel()
    }
    
    private func getProteinLabel() -> UILabel {
        return UILabel()
    }
    
    private func getLeftBottomChevron() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = R.image.openMainWidget.downChevron()
        return view
    }
    
    private func getRightBottomChevron() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = R.image.openMainWidget.downChevron()
        view.tintColor = R.color.openMainWidget.background()
        return view
    }
}
