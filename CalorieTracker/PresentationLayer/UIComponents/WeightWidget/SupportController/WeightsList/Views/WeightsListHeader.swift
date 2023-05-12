//
//  WeightsListHeader.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 26.04.2023.
//

import UIKit

final class WeightsListHeader: UIView {
    var segmentChanged: ((HistoryHeaderButtonType) -> Void)?
    var HKselectorChanged: ((Bool) -> Void)?
    private var blurRadiusDriver: UIViewPropertyAnimator?
    var HKisOn: Bool {
        get {
            switcher.isOn
        }
        set {
            switcher.isOn = newValue
        }
    }
    
    private let healthKitImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.onboardings.healthApp()
        return imageView
    }()
    
    let blurView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        return visualEffectView
    }()
    
    let switcher: UISwitch = {
        let switcher = UISwitch()
        switcher.isOn = UDM.weightsListShouldShowHKRecords
        return switcher
    }()
    
    private let appleHealthLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 18)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 2
        label.text = R.string.localizable.weightsListHealthRecords()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupSubviews()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        reinitBlurView()
    }
    
    private func setupAppearance() {
        backgroundColor = .white.withAlphaComponent(0.9)
    }
    
    func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurView.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.1
    }
    
    private lazy var segmentedControl: SegmentedControl<HistoryHeaderButtonType> = {
        typealias ButtonType = SegmentedButton<HistoryHeaderButtonType>.Model
        let view = SegmentedControl<HistoryHeaderButtonType>(
            [
                ButtonType(
                    title: HistoryHeaderButtonType.listDaily.getTitle(),
                    normalColor: R.color.weightWidget.segmentedButton(),
                    selectedColor: R.color.weightWidget.weightTextColor(),
                    id: .listDaily
                ),
                ButtonType(
                    title: HistoryHeaderButtonType.listWeekly.getTitle(),
                    normalColor: R.color.weightWidget.segmentedButton(),
                    selectedColor: R.color.weightWidget.weightTextColor(),
                    id: .listWeekly
                ),
                ButtonType(
                    title: HistoryHeaderButtonType.listMonthly.getTitle(),
                    normalColor: R.color.weightWidget.segmentedButton(),
                    selectedColor: R.color.weightWidget.weightTextColor(),
                    id: .listMonthly
                )
            ]
        )
        view.backgroundColor = R.color.weightWidget.segmentedControl()
        view.selectedButtonType = .listDaily
        return view
    }()
    
    private func setupSubviews() {
        addSubview(blurView)
        blurView.contentView.addSubviews(healthKitImage, appleHealthLabel, switcher, segmentedControl)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        healthKitImage.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.top.equalToSuperview().offset(56)
            make.leading.equalToSuperview().offset(20)
        }
        
        appleHealthLabel.snp.makeConstraints { make in
            make.height.equalTo(healthKitImage)
            make.leading.equalTo(healthKitImage.snp.trailing)
            make.trailing.equalTo(switcher.snp.leading).offset(-4)
            make.centerY.equalTo(healthKitImage)
        }
        
        switcher.snp.makeConstraints { make in
            make.width.equalTo(51)
            make.height.equalTo(31)
            make.leading.equalTo(appleHealthLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(appleHealthLabel)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(healthKitImage.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
    }
    
    private func setupActions() {
        segmentedControl.onSegmentChanged = { [weak self] model in
            self?.segmentChanged?(model.id)
        }
        
        switcher.addTarget(self, action: #selector(hkSelectorChanged(sender:)), for: .touchUpInside)
    }
    
    @objc private func hkSelectorChanged(sender: UISwitch) {
        HKselectorChanged?(sender.isOn)
    }
}
