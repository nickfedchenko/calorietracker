//
//  MealTimeHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 02.02.2023.
//

import UIKit

final class MealTimeHeaderView: UIView {
    enum HeaderState {
        case collapsed, expanded
    }
    
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
    
    var addButtonHandler: (() -> Void)?
    
    private let shadowView = ViewWithShadow([
        .init(color: .black, opacity: 0.03, offset: CGSize(width: 0, height: 6), radius: 8),
        .init(color: .black, opacity: 0.03, offset: CGSize(width: 0, height: 1), radius: 16)
    ])
    
    var state: HeaderState = .collapsed {
        didSet {
            updateCorners()
            updateChevrons()
        }
    }
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addButton.layer.cornerRadius = addButton.frame.height / 2.0
    }
    
    func updateChevrons() {
        if state == .expanded {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.leftBottomChevron.transform = CGAffineTransform(rotationAngle: .pi / 180 * 180)
                self.rightBottomChevron.transform = CGAffineTransform(rotationAngle: .pi / 180 * 180)
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0) {
                self.leftBottomChevron.transform = .identity
                self.rightBottomChevron.transform = .identity
            }
        }
    }
    
    private func updateCorners() {
//        shadowView.layer.maskedCorners = state == .collapsed ? [.allCorners] : [.topCorners]
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
        
        carbsLabel.attributedText = getAttributedString(
            nutrient: .carbs,
            value: viewModel.carbs
        )
        
        fatLabel.attributedText = getAttributedString(
            nutrient: .fat,
            value: viewModel.fat
        )
        proteinLabel.attributedText = getAttributedString(
            nutrient: .protein,
            value: viewModel.protein
        )
        leftBottomChevron.isHidden = !viewModel.shouldShowChevrons
        rightBottomChevron.isHidden = !viewModel.shouldShowChevrons
    }
    
    private func getAttributedString(nutrient: NutrientType, value: Int) -> NSAttributedString? {
        let font = R.font.sfCompactDisplayMedium(size: 15.fontScale())
        let fontSecond = R.font.sfProTextMedium(size: 15.fontScale())
        return "\(nutrient.getTitle(.short) ?? ""): \(value)".attributedSring(
            [
                .init(
                    worldIndex: [0],
                    attributes: [.font(font), .color(nutrient.getColor())]
                ),
                .init(
                    worldIndex: [1],
                    attributes: [.font(fontSecond), .color(R.color.openMainWidget.dark())]
                )
            ]
        )
    }
    
    private func setupView() {
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 12
        shadowView.layer.maskedCorners = [.allCorners]
        addButton.layer.cornerCurve = .circular
    }
    
    private func setupConstraints() {
        let stack: UIStackView = {
            let view = UIStackView()
            view.spacing = 16
            view.axis = .horizontal
            view.distribution = .equalSpacing
            return view
        }()
        
        addSubviews(
//            shadowView,
            mealTimeImageView,
            mealTimeLabel,
            burnKcalImageView,
            burnKcalLabel,
            stack,
            addButton,
            leftBottomChevron,
            rightBottomChevron
        )
        
        stack.addArrangedSubviews(
            carbsLabel,
            proteinLabel,
            fatLabel
        )
        
//        shadowView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
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
//            make.top.greaterThanOrEqualToSuperview()
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
            make.centerY.equalTo(leftBottomChevron)
            make.height.equalTo(24)
            make.leading.equalTo(mealTimeLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(rightBottomChevron.snp.trailing)
        }
        
        leftBottomChevron.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
            make.top.equalTo(mealTimeImageView.snp.bottom).offset(1)
            make.bottom.equalToSuperview().inset(7)
        }
        
        rightBottomChevron.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(24)
//            make.top.equalTo(addButton.snp.bottom).offset(4)
            make.centerY.equalTo(leftBottomChevron)
//            make.bottom.equalToSuperview().offset(-7)
        }
    }
    
    @objc private func didTapAddButton() {
        addButtonHandler?()
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
        label.font = R.font.sfProRoundedBold(size: 18.fontScale())
        return label
    }
    
    private func getBurnKcalImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .center
        view.image = R.image.openMainWidget.burn()
        return view
    }
    
    private func getBurnKcalLabel() -> UILabel {
        let label = UILabel()
        label.textColor = R.color.openMainWidget.dark()
        label.font = R.font.sfProRoundedBold(size: 18.fontScale())
        return label
    }
    
    private func getAddButton() -> UIButton {
        let button = UIButton()
        button.layer.cornerCurve = .circular
        button.setImage(R.image.openMainWidget.add(), for: .normal)
        button.backgroundColor = R.color.openMainWidget.background()
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
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
        view.contentMode = .center
        return view
    }
    
    private func getRightBottomChevron() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = R.image.openMainWidget.downChevron()
        view.tintColor = R.color.openMainWidget.background()
        view.contentMode = .center
        return view
    }
}
