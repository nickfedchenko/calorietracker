//
//  WaterFullWidgetView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import UIKit

protocol WaterFullWidgetInterface: AnyObject {
    
}

protocol WaterFullWidgetOutput: AnyObject {
    func setGoal(_ widget: WaterFullWidgetView)
    func setQuickAdd(_ widget: WaterFullWidgetView, complition: @escaping (QuickAddModel) -> Void)
}

final class WaterFullWidgetView: UIView, CTWidgetFullProtocol {
    var didTapCloseButton: (() -> Void)?
    weak var output: WaterFullWidgetOutput?
    
    private lazy var waterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        label.textColor = R.color.waterWidget.firstGradientColor()
        label.text = "WATER"
        return label
    }()
    
    private lazy var quickAddTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 18.fontScale())
        label.textColor = R.color.waterWidget.firstGradientColor()
        label.text = "Set up quick add"
        return label
    }()
    
    private lazy var waterValueLabel: UILabel = {
        let view = UILabel()
        view.font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        return view
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.waterWidget.openSettings(), for: .normal)
        button.setImage(R.image.waterWidget.closeSettings(), for: .selected)
        return button
    }()
    
    private lazy var slider: WaterSliderView = {
        let slider = WaterSliderView()
        
        return slider
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.waterWidget.close(), for: .normal)
        return button
    }()
    
    private lazy var logoView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.waterWidget.waterLogo()
        return view
    }()
    
    private lazy var progressView: LineProgressView = {
        let view = LineProgressView()
        view.isHiddenFlag = true
        view.backgroundLineColor = R.color.waterWidget.backgroundColor()
        view.colors = [
            R.color.waterWidget.firstGradientColor(),
            R.color.waterWidget.secondGradientColor()
        ]
        return view
    }()
    
    private lazy var trackButton: BasicButtonView = {
        let button = BasicButtonView(
            type: .custom(
                CustomType(
                    image: CustomType.Image(
                        isPressImage: R.image.waterWidget.pressButton(),
                        defaultImage: R.image.waterWidget.defaultButton(),
                        inactiveImage: nil
                    ),
                    title: CustomType.Title(
                        isPressTitleColor: UIColor.white,
                        defaultTitleColor: UIColor.white
                    ),
                    backgroundColorInactive: nil,
                    backgroundColorDefault: R.color.waterWidget.secondGradientColor(),
                    backgroundColorPress: R.color.waterWidget.backgroundColor(),
                    gradientColors: nil,
                    borderColorInactive: nil,
                    borderColorDefault: R.color.waterWidget.firstGradientColor(),
                    borderColorPress: UIColor.white
                )
            )
        )
        
        button.defaultTitle = "TRACK"
        button.isPressTitle = "TRACK"
        
        return button
    }()
    
    private lazy var goalButton: BasicButtonView = {
        let button = BasicButtonView(
            type: .custom(
                CustomType(
                    image: CustomType.Image(
                        isPressImage: R.image.waterWidget.goalPress(),
                        defaultImage: R.image.waterWidget.goalDefault(),
                        inactiveImage: nil
                    ),
                    title: CustomType.Title(
                        isPressTitleColor: UIColor.white,
                        defaultTitleColor: UIColor.white
                    ),
                    backgroundColorInactive: nil,
                    backgroundColorDefault: R.color.waterWidget.secondGradientColor(),
                    backgroundColorPress: R.color.waterWidget.backgroundColor(),
                    gradientColors: nil,
                    borderColorInactive: nil,
                    borderColorDefault: R.color.waterWidget.firstGradientColor(),
                    borderColorPress: UIColor.white
                )
            )
        )
        
        button.defaultTitle = "CHANGE DAILY GOAL"
        button.isPressTitle = "CHANGE DAILY GOAL"
        
        return button
    }()
    
    private lazy var quickAddStack: QuickAddStackView = {
        let stack = QuickAddStackView()
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private var isSelectedSettingsButton = false
    private var presenter: WaterFullWidgetPresenterInterface?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        presenter = WaterFullWidgetPresenter(view: self)
        setupView()
        setupConstraints()
        configureView()
        
        quickAddStack.didTapQuickAdd = { value in
            self.presenter?.addWater(value)
            self.configureView()
        }
        
        quickAddStack.didTapEdit = { complition in
            self.output?.setQuickAdd(self, complition: { model in
                self.presenter?.addQuickAddTypes(model)
                complition(model)
            })
        }
        
        if let viewsType = presenter?.getQuickAddTypes() {
            quickAddStack.viewsType = viewsType
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        configureView()
    }
    
    // MARK: - Setup View
    
    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        settingsButton.addTarget(self,
                                 action: #selector(didTapSettingsButton),
                                 for: .touchUpInside)
        trackButton.addTarget(self,
                              action: #selector(didTapTrackButton),
                              for: .touchUpInside)
        goalButton.addTarget(self,
                             action: #selector(didTapGoalButton),
                             for: .touchUpInside)
        closeButton.addTarget(self,
                              action: #selector(didTapBottomCloseButton),
                              for: .touchUpInside)
        slider.delegate = self
        
        addSubviews([
            waterTitleLabel,
            settingsButton,
            waterValueLabel,
            logoView,
            mainStack,
            closeButton
        ])
        
        mainStack.addArrangedSubviews(
            progressView,
            goalButton,
            slider,
            quickAddTitleLabel,
            quickAddStack,
            trackButton
        )
    }
    
    private func setupConstraints() {
        waterTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(waterTitleLabel)
            make.trailing.equalToSuperview().offset(-22)
        }
        
        waterValueLabel.snp.makeConstraints { make in
            make.top.equalTo(waterTitleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalTo(settingsButton.snp.leading).offset(-11)
        }
        
        closeButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(waterValueLabel.snp.bottom).offset(17)
            make.bottom.lessThanOrEqualTo(closeButton.snp.top).offset(-10)
        }
        
        goalButton.aspectRatio(0.187)
        slider.aspectRatio(0.24)
        trackButton.aspectRatio(0.187)
        quickAddStack.aspectRatio(0.187)
        
        progressView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
    }
    
    private func configureView() {
        quickAddStack.isEdit = isSelectedSettingsButton
        slider.step = 0
        slider.stepVolume = presenter?.getSliderStepVolume() ?? 0
        slider.countParts = presenter?.getCountSliderParts() ?? 0
        let goal = presenter?.getGoal() ?? 1
        let valueNow = presenter?.getValueNow() ?? 0
        switch isSelectedSettingsButton {
        case true:
            configureLabel(
                value: valueNow,
                goal: nil
            )
            quickAddStack.isHidden = false
            quickAddTitleLabel.isHidden = false
            goalButton.isHidden = false
            progressView.isHidden = true
            slider.isHidden = true
            trackButton.isHidden = true
            logoView.isHidden = true
        case false:
            progressView.progress = CGFloat(valueNow) / CGFloat(goal)
            configureLabel(
                value: valueNow,
                goal: goal
            )
            quickAddStack.isHidden = false
            quickAddTitleLabel.isHidden = true
            goalButton.isHidden = true
            progressView.isHidden = false
            slider.isHidden = false
            trackButton.isHidden = true
            logoView.isHidden = false
        }
    }
    
    // MARK: - setup String
    
    private func configureLabel(value: Int, goal: Int?) {
        let suffix = BAMeasurement.measurmentSuffix(.liquid).uppercased()
        let string = goal == nil
        ? "TODAY \(value) \(suffix)"
            : "\(value) / \(goal ?? 0) \(suffix)"
        let colorLeft = R.color.waterWidget.secondGradientColor()
        let colorRight = R.color.waterWidget.firstGradientColor()
        let font = R.font.sfProDisplaySemibold(size: 22.fontScale())
        let leftAttributes: [StringSettings] = [.color(colorLeft), .font(font)]
        let rightAttributes: [StringSettings] = [.color(colorRight), .font(font)]
        
        if goal != nil {
            waterValueLabel.attributedText = string.attributedString([
                .init(worldIndex: [0], attributes: leftAttributes),
                .init(worldIndex: [1, 2, 3, 4], attributes: rightAttributes)
            ])
        } else {
            waterValueLabel.attributedText = string.attributedString(
                [
                    .init(worldIndex: [0, 1], attributes: leftAttributes),
                    .init(worldIndex: [2, 3], attributes: rightAttributes)
                ],
                image: .init(
                    image: R.image.waterWidget.editText(),
                    font: font,
                    position: .right
                )
            )
        }
    }
    
    // MARK: - Selectors
    
    @objc private func didTapSettingsButton(_ sender: UIButton) {
        Vibration.rigid.vibrate()
        isSelectedSettingsButton = !isSelectedSettingsButton
        switch isSelectedSettingsButton {
        case true:
            settingsButton.setImage(R.image.waterWidget.closeSettings(), for: .normal)
        case false:
            settingsButton.setImage(R.image.waterWidget.openSettings(), for: .normal)
        }
        
        configureView()
    }
    
    @objc private func didTapGoalButton(_ sender: UIButton) {
        Vibration.rigid.vibrate()
        output?.setGoal(self)
    }
    
    @objc private func didTapTrackButton(_ sender: UIButton) {
        Vibration.success.vibrate()
        presenter?.addWater(slider.stepVolume * slider.step)
        configureView()
    }
    
    @objc private func didTapBottomCloseButton() {
        Vibration.rigid.vibrate()
        didTapCloseButton?()
    }
}

// MARK: - Slider Delegate

extension WaterFullWidgetView: WaterSliderViewDelegate {
    func beginTracking() {
        trackButton.isHidden = false
        quickAddStack.isHidden = true
    }
    
    func endTracking(_ value: Int) {
        if value == 0 {
            quickAddStack.isHidden = false
            trackButton.isHidden = true
        }
    }
}

extension WaterFullWidgetView: WaterFullWidgetInterface {
    
}
