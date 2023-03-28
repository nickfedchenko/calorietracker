//
//  WaterFullWidgetView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import UIKit

protocol TransitionAnimationReady: UIView {
    func prepareForAppearing()
    func animateAppearingFirstStage(targetFrame: CGRect, completion: @escaping () -> Void)
    func animateAppearingSecondStage()
    func prepareForDisappearing()
    func animateDisappearing()
}

protocol WaterFullWidgetInterface: AnyObject {
    
}

protocol WaterFullWidgetOutput: AnyObject {
    func setGoal(_ widget: WaterFullWidgetView)
    func setQuickAdd(_ widget: WaterFullWidgetView, complition: @escaping (QuickAddModel) -> Void)
}

final class WaterFullWidgetView: UIView, CTWidgetFullProtocol {
    var didChangeSelectedDate: ((Date) -> Void)?
    
    var didTapCloseButton: (() -> Void)?
    weak var output: WaterFullWidgetOutput?
    
    private lazy var waterTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 22)
        label.textColor = R.color.waterWidget.firstGradientColor()
        label.text = R.string.localizable.diagramChartTypeWaterTitle()
        label.clipsToBounds = false
        return label
    }()
    
    private lazy var quickAddTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 16)
        label.textColor = R.color.waterWidget.firstGradientColor()
        label.text = "Set up quick add"
        return label
    }()
    
    private lazy var waterValueLabel: UILabel = {
        let view = UILabel()
        view.clipsToBounds = false
        view.font = R.font.sfProRoundedBold(size: 22)
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
    
    let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 24)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let percentTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 13)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "%"
        return label
    }()
    
    private var isSelectedSettingsButton = false
    private var presenter: WaterFullWidgetPresenterInterface?
    
    
    init(with pointDate: Date) {
        super.init(frame: .zero)
        presenter = WaterFullWidgetPresenter(view: self, specificDate: pointDate)
        setupView()
        setupConstraints()
        configureView()
        
        quickAddStack.didTapQuickAdd = { value in
            self.presenter?.addWater(value)
            self.configureView()
            LoggingService.postEvent(event: .waterquickbutton)
        }
        
        quickAddStack.didTapEdit = { complition in
            self.output?.setQuickAdd(self, complition: { model in
                self.presenter?.addQuickAddTypes(model)
                complition(model)
                LoggingService.postEvent(event: .watersetmeasure)
            })
        }
        
        if let viewsType = presenter?.getQuickAddTypes() {
            quickAddStack.viewsType = viewsType
        }
    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        presenter = WaterFullWidgetPresenter(view: self)
//        setupView()
//        setupConstraints()
//        configureView()
//
//        quickAddStack.didTapQuickAdd = { value in
//            self.presenter?.addWater(value)
//            self.configureView()
//        }
//
//        quickAddStack.didTapEdit = { complition in
//            self.output?.setQuickAdd(self, complition: { model in
//                self.presenter?.addQuickAddTypes(model)
//                complition(model)
//            })
//        }
//
//        if let viewsType = presenter?.getQuickAddTypes() {
//            quickAddStack.viewsType = viewsType
//        }
//    }

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
        
        logoView.addSubviews(percentageLabel, percentTitleLabel)
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
        mainStack.setCustomSpacing(20, after: slider)
        
        progressView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        
        percentageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(30.5)
            make.width.greaterThanOrEqualTo(34)
        }
        
        percentTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(percentageLabel)
            make.top.equalToSuperview().offset(54.5)
        }
    }
    
    private func configureView() {
        quickAddStack.isEdit = isSelectedSettingsButton
        slider.step = 0
        slider.stepVolume = presenter?.getSliderStepVolume() ?? 0
        slider.countParts = presenter?.getCountSliderParts() ?? 0
        let goal = presenter?.getGoal() ?? 1
        let valueNow = presenter?.getValueNow() ?? 0
        if valueNow >= goal {
            LoggingService.postEvent(event: .watergoal)
        }
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
        let colorRight = UIColor(hex: "A7F0ED")
        let font = R.font.sfProRoundedBold(size: 22)
        let leftAttributes: [StringSettings] = [.color(colorLeft), .font(font)]
        let rightAttributes: [StringSettings] = [.color(colorRight), .font(font)]
        let percentage = (presenter?.getPercentage() ?? 0) * 100
        let percentageString = String(format: "%.0f", percentage)
        percentageLabel.text = percentageString
        if goal != nil {
            waterValueLabel.attributedText = string.attributedSring([
                .init(worldIndex: [0], attributes: leftAttributes),
                .init(worldIndex: [1, 2, 3, 4], attributes: rightAttributes)
            ])
        } else {
            waterValueLabel.attributedText = string.attributedSring(
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
        LoggingService.postEvent(event: .watersetmanual)
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

extension WaterFullWidgetView: TransitionAnimationReady {
    
    func prepareForAppearing() {
        waterTitleLabel.font = R.font.sfProRoundedBold(size: 18)
        settingsButton.alpha = 0
        quickAddStack.alpha = 0
        settingsButton.snp.remakeConstraints { make in
            make.centerY.equalTo(waterTitleLabel)
            make.trailing.equalToSuperview().offset(23)
        }
        mainStack.snp.removeConstraints()
        logoView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalTo(settingsButton.snp.leading).offset(-11)
        }
        
        waterTitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(logoView)
            make.leading.equalToSuperview().offset(8)
        }
        
        waterValueLabel.snp.remakeConstraints { make in
            make.top.equalTo(waterTitleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(8)
            make.height.equalTo(24)
        }
        
        mainStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(logoView.snp.bottom).offset(11)
//            make.bottom.lessThanOrEqualTo(closeButton.snp.top).offset(-10)
        }
        
        let goal = presenter?.getGoal() ?? 1
        let valueNow = presenter?.getValueNow() ?? 0
        let suffix = BAMeasurement.measurmentSuffix(.liquid).uppercased()
        let string = goal == nil
        ? "TODAY \(valueNow) \(suffix)"
            : "\(valueNow) / \(goal ?? 0) \(suffix)"
        let colorLeft = R.color.waterWidget.secondGradientColor()
        let colorRight = UIColor(hex: "A7F0ED")
        let font = R.font.sfProRoundedBold(size: 18)
        let leftAttributes: [StringSettings] = [.color(colorLeft), .font(font)]
        let rightAttributes: [StringSettings] = [.color(colorRight), .font(font)]
        if goal != nil {
            waterValueLabel.attributedText = string.attributedSring([
                .init(worldIndex: [0], attributes: leftAttributes),
                .init(worldIndex: [1, 2, 3, 4], attributes: rightAttributes)
            ])
        } else {
            waterValueLabel.attributedText = string.attributedSring(
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
        closeButton.alpha = 0
        goalButton.alpha = 0
        slider.alpha = 0
        quickAddTitleLabel.alpha = 0
        quickAddStack.alpha = 0
        trackButton.alpha = 0
        slider.alpha = 0
        slider.shouldShowInnerShadow = false
        layoutIfNeeded()
        mainStack.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    func animateAppearingFirstStage(targetFrame: CGRect, completion: @escaping () -> Void) {
        settingsButton.snp.updateConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
        }

        logoView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(20)
        }

        waterTitleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        
        waterValueLabel.snp.remakeConstraints { make in
            make.top.equalTo(waterTitleLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        
        mainStack.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(waterValueLabel.snp.bottom).offset(17)
            make.bottom.lessThanOrEqualTo(closeButton.snp.top).offset(-10)
        }
            
        self.waterValueLabel.animate(
            font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22),
            duration: 0.4
        )
        self.waterTitleLabel.animate(
            font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22),
            duration: 0.4
        )
       
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.7
        ) {
            self.settingsButton.alpha = 1
            self.frame = targetFrame
            self.layoutIfNeeded()
//            self.mainStack.layoutIfNeeded()
            self.quickAddStack.alpha = 1
            self.closeButton.alpha = 1
            self.goalButton.alpha = 1
            self.slider.alpha = 1
            self.quickAddTitleLabel.alpha = 1
            self.quickAddStack.alpha = 1
            self.trackButton.alpha = 1
            self.slider.alpha = 1
            self.slider.layoutIfNeeded()
            self.slider.setNeedsDisplay()
//            self.progressView.setNeedsLayout()
        } completion: { _ in
            completion()
        }
    }
    
    func animateAppearingSecondStage() {
        self.quickAddStack.alpha = 1
        closeButton.alpha = 1
        goalButton.alpha = 1
        slider.alpha = 1
        quickAddTitleLabel.alpha = 1
        quickAddStack.alpha = 1
        trackButton.alpha = 1
    }
    
    func prepareForDisappearing() {
        UIView.animate(withDuration: 0.3) {
            self.settingsButton.alpha = 0
        }
    }
    
    func animateDisappearing() {
        UIView.animate(withDuration: 0.3) {
            self.settingsButton.alpha = 0
        }
    }
    
}
