//
//  LandingBenefitsCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingCheckmarksCell: UICollectionViewCell {
    static let identifier = String(describing: LandingCheckmarksCell.self)
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
//        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.alignment = .leading
//        stack.setContentHuggingPriority(.required, for: .vertical)
        stack.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainStack.removeAllArrangedSubviews()
    }
    
    func configure(with model: CheckmarkSectionModel) {
        mainTitle.text = model.headerTitle
        mainTitle.textColor = model.allTextColor
        mainTitle.font = model.headerTitleFont
        
        let horizontalStackPhysically = UIStackView()
        horizontalStackPhysically.axis = .horizontal
        horizontalStackPhysically.spacing = 8
        horizontalStackPhysically.distribution = .fillProportionally
        horizontalStackPhysically.alignment = .center
        
        // first line
        let checkmark = UIImageView(image: R.image.landing.benefitsSection.chekmark())
        let feelingLabel = UILabel()
        feelingLabel.textAlignment = .left
        feelingLabel.textColor = model.allTextColor
        feelingLabel.font = R.font.sfProDisplayMedium(size: 18)
        feelingLabel.text = R.string.localizable.landingCheckmarksSectionPhysicallyFeeling()
        horizontalStackPhysically.addArrangedSubviews(checkmark, feelingLabel)
        mainStack.addArrangedSubview(horizontalStackPhysically)
        // second line
        let horizontalPerfect = UIStackView()
        horizontalPerfect.axis = .horizontal
        horizontalPerfect.spacing = 8
        horizontalPerfect.distribution = .fillProportionally
        horizontalPerfect.alignment = .center
    
        let checkmarkPerfect = UIImageView(image: R.image.landing.benefitsSection.chekmark())
        let perfectLabel = UILabel()
        perfectLabel.textAlignment = .left
        perfectLabel.textColor = model.allTextColor
        perfectLabel.font = R.font.sfProDisplayMedium(size: 18)
        var perfectText = R.string.localizable.landingCheckmarksSectionPerfectFor()
        let dateOfBirth = UDM.userData?.dateOfBirth ?? Date()
        let currentDate = Date()
        let years = abs(Calendar.current.dateComponents([.year], from: dateOfBirth, to: currentDate).year ?? 29) - 1
        var sexString = UDM.userData?.sex.getTitle(.short)?.lowercased() ?? "male"
        sexString.removeLast(1)
        perfectText = perfectText.replacingOccurrences(
            of: "@sex@",
            with: sexString
        )
        perfectText = perfectText.replacingOccurrences(of: "@age@", with: "\(years)")
        perfectLabel.text = perfectText
        horizontalPerfect.addArrangedSubviews(checkmarkPerfect, perfectLabel)
        mainStack.addArrangedSubview(horizontalPerfect)
         // third line
        if !UDM.restrictions.isEmpty {
            let horizontalRestrictions = UIStackView()
            horizontalRestrictions.axis = .horizontal
            horizontalRestrictions.spacing = 8
            horizontalRestrictions.distribution = .equalSpacing
            horizontalRestrictions.alignment = .leading
            let checkmarkRestrictions = UIImageView(image: R.image.landing.benefitsSection.chekmark())
            checkmarkRestrictions.setContentCompressionResistancePriority(.required, for: .horizontal)
            let restrictionsLabel = UILabel()
            restrictionsLabel.numberOfLines = 0
            restrictionsLabel.textAlignment = .left
            restrictionsLabel.textColor = model.allTextColor
            restrictionsLabel.font = R.font.sfProDisplayMedium(size: 18)
            var restrictionsTextBody = R.string.localizable.landingCheckmarksSectionAllergicRestrictions()
            let restrictionsActualString = UDM.restrictions.compactMap { $0.description }.joined(separator: ", ")
            restrictionsTextBody += restrictionsActualString
            horizontalRestrictions.addArrangedSubviews(checkmarkRestrictions, restrictionsLabel)
            restrictionsLabel.text = restrictionsTextBody
            mainStack.addArrangedSubview(horizontalRestrictions)
        }
        
        // fourth line
        let horizontalActivityStack = UIStackView()
        horizontalActivityStack.axis = .horizontal
        horizontalActivityStack.spacing = 8
        horizontalActivityStack.distribution = .fillProportionally
        horizontalActivityStack.alignment = .center
        let checkmarkActivity = UIImageView(image: R.image.landing.benefitsSection.chekmark())
        let activityLabel = UILabel()
        activityLabel.textAlignment = .left
        activityLabel.textColor = model.allTextColor
        activityLabel.font = R.font.sfProDisplayMedium(size: 18)
        var activityLabelText = R.string.localizable.landingCheckmarksSectionActivityLifeStyle()
        + (UDM.activityLevel?.getTitle(.short) ?? "moderate")
        activityLabel.text = activityLabelText
        horizontalActivityStack.addArrangedSubviews(checkmarkActivity, activityLabel)
        mainStack.addArrangedSubview(horizontalActivityStack)
        // fifth line
        let horizontalWeeklyGoalStack = UIStackView()
        horizontalWeeklyGoalStack.axis = .horizontal
        horizontalWeeklyGoalStack.spacing = 8
        horizontalWeeklyGoalStack.distribution = .fillProportionally
        horizontalWeeklyGoalStack.alignment = .center
        let checkmarkWeeklyGoal = UIImageView(image: R.image.landing.benefitsSection.chekmark())
        let weeklyGoalLabel = UILabel()
        weeklyGoalLabel.textAlignment = .left
        weeklyGoalLabel.textColor = model.allTextColor
        weeklyGoalLabel.font = R.font.sfProDisplayMedium(size: 18)
        var weeklyGoalText = R.string.localizable.landingCheckmarksSectionWeeklyGoal()
        weeklyGoalText += BAMeasurement(UDM.weeklyGoal ?? -1, .weight).string(with: 2)
        weeklyGoalLabel.text = weeklyGoalText
        horizontalWeeklyGoalStack.addArrangedSubviews(checkmarkWeeklyGoal, weeklyGoalLabel)
        mainStack.addArrangedSubview(horizontalWeeklyGoalStack)
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubviews(mainTitle, mainStack)
        mainTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(mainTitle.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(32)
        }
    }
}
