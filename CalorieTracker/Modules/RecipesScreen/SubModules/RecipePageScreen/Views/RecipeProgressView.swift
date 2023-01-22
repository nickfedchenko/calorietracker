//
//  RecipeProgressView.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.01.2023.
//

import UIKit

final class RecipeProgressView: UIView {
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        label.font = R.font.sfProRoundedSemibold(size: 17)
        label.text = "Percent of daily goal".localized
        return label
    }()
    
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "B3EFDE")
        return view
    }()
    
    private lazy var carbsPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        if case let .carbs(total: total, possible: possible, eaten: eaten ) = carbsData {
            let percent = (possible / total) * 100
            let percentString = String(
                format: "%.\(percent.truncatingRemainder(dividingBy: 1) >= 0.1 ? "1" : "0")f",
                (possible / total) * 100
            ) + "%"
            label.text = percentString
            label.textColor = possible + eaten <= total ? UIColor(hex: "547771") : UIColor(hex: "FF0000")
        }
        return label
    }()
    
    private lazy var proteinPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        if case let .protein(total: total, possible: possible, eaten: eaten ) = proteinData {
            let percent = (possible / total) * 100
            let percentString = String(
                format: "%.\(percent.truncatingRemainder(dividingBy: 1) >= 0.1 ? "1" : "0")f",
                (possible / total) * 100
            ) + "%"
            label.textColor = possible + eaten <= total ? UIColor(hex: "547771") : UIColor(hex: "FF0000")
            label.text = percentString
        }
        return label
    }()
    
    private lazy var fatPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        if case let .fat(total: total, possible: possible, eaten: eaten ) = fatData {
            let percent = (possible / total) * 100
            let percentString = String(
                format: "%.\(percent.truncatingRemainder(dividingBy: 1) >= 0.1 ? "1" : "0")f",
                (possible / total) * 100
            ) + "%"
            label.textColor = possible + eaten <= total ? UIColor(hex: "547771") : UIColor(hex: "FF0000")
            label.text = percentString
        }
        return label
    }()
    
    private lazy var kcalPercentageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 16)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        if case let .kcal(total: total, possible: possible, eaten: eaten ) = kcalData {
            let percent = (possible / total) * 100
            let percentString = String(
                format: "%.\(percent.truncatingRemainder(dividingBy: 1) >= 0.1 ? "1" : "0")f",
                (possible / total) * 100
            ) + "%"
            label.textColor = possible + eaten <= total ? UIColor(hex: "547771") : UIColor(hex: "FF0000")
            label.text = percentString
        }
        return label
    }()
    
    var carbsData: RecipeRoundProgressView.ProgressMode
    var kcalData: RecipeRoundProgressView.ProgressMode
    var fatData: RecipeRoundProgressView.ProgressMode
    var proteinData: RecipeRoundProgressView.ProgressMode
    
    lazy var carbsProgressView: RecipeRoundProgressView = {
        let view = RecipeRoundProgressView(currentMode: carbsData)
        return view
    }()
    
    lazy var kcalProgressView: RecipeRoundProgressView = {
        let view = RecipeRoundProgressView(currentMode: kcalData)
        return view
    }()
    
    lazy var proteinProgressView: RecipeRoundProgressView = {
        let view = RecipeRoundProgressView(currentMode: proteinData)
        return view
    }()
    
    lazy var fatProgressView: RecipeRoundProgressView = {
        let view = RecipeRoundProgressView(currentMode: fatData)
        return view
    }()
    
    var progressViewsOffset: CGFloat {
        ((UIScreen.main.bounds.width - 40) - (72 * 4)) / 5
    }
    
    init(
        carbsData: RecipeRoundProgressView.ProgressMode,
        kcalData: RecipeRoundProgressView.ProgressMode,
        fatData: RecipeRoundProgressView.ProgressMode,
        proteinData: RecipeRoundProgressView.ProgressMode
    ) {
        self.carbsData = carbsData
        self.kcalData = kcalData
        self.fatData = fatData
        self.proteinData = proteinData
        super.init(frame: .zero)
        setupSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateProgress() {
        [carbsProgressView, proteinProgressView, fatProgressView, kcalProgressView].forEach {
            $0.animateProgress()
        }
    }
    
    private func setupSubviews() {
        addSubviews(
            mainTitle,
            separatorLineView,
            carbsPercentageLabel,
            proteinPercentageLabel,
            fatPercentageLabel,
            kcalPercentageLabel,
            carbsProgressView,
            proteinProgressView,
            fatProgressView,
            kcalProgressView
        )
        
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        separatorLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(progressViewsOffset)
            make.top.equalTo(mainTitle.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        carbsProgressView.snp.makeConstraints { make in
            make.leading.equalTo(separatorLineView)
            make.width.height.equalTo(72)
            make.top.equalTo(separatorLineView.snp.bottom).offset(41)
        }
        
        proteinProgressView.snp.makeConstraints { make in
            make.leading.equalTo(carbsProgressView.snp.trailing).offset(progressViewsOffset)
            make.width.height.equalTo(72)
            make.top.equalTo(carbsProgressView)
        }
        
        fatProgressView.snp.makeConstraints { make in
            make.leading.equalTo(proteinProgressView.snp.trailing).offset(progressViewsOffset)
            make.width.height.equalTo(72)
            make.top.equalTo(carbsProgressView)
            make.bottom.equalToSuperview().inset(16)
        }
        
        kcalProgressView.snp.makeConstraints { make in
            make.leading.equalTo(fatProgressView.snp.trailing).offset(progressViewsOffset)
            make.width.height.equalTo(72)
            make.top.equalTo(carbsProgressView)
        }
        
        carbsPercentageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(carbsProgressView)
            make.bottom.equalTo(carbsProgressView.snp.top).inset(-8)
        }
        
        proteinPercentageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(proteinProgressView)
            make.bottom.equalTo(proteinProgressView.snp.top).inset(-8)
        }
        
        fatPercentageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(fatProgressView)
            make.bottom.equalTo(fatProgressView.snp.top).inset(-8)
        }
        
        kcalPercentageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(kcalProgressView)
            make.bottom.equalTo(kcalProgressView.snp.top).inset(-8)
        }
    }
    
    private func setupAppearance() {
        backgroundColor = .clear
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor(hex: "#B3EFDE").cgColor
    }
}
