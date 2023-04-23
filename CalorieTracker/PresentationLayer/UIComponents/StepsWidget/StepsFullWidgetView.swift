//
//  StepsFullWidgetView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.08.2022.
//

import UIKit

protocol StepsFullWidgetAnimatableProtocol: UIView {
    func getWidgetContainerFrame() -> CGRect
    func getFrameForTopTitle() -> CGRect
    func getMainButtonFrame() -> CGRect
    func getProgressContainerFrame() -> CGRect
    func getStraightLinePath() -> CGPath?
    func getFlagFrame() -> CGRect
    func closeButtonFrame() -> CGRect
    func getGradientControlPoints() -> (startPoint: CGPoint, endPoint: CGPoint)
    func getBackgroundLinePath() -> CGPath?
}

protocol StepsFullWidgetOutput: AnyObject {
    func setGoal(_ widget: StepsFullWidgetView)
}

protocol StepsFullWidgetInterface: AnyObject {
    func setModel(_ model: StepsFullWidgetView.Model)
}

// TODO: - Нужно получать данные 
protocol StepsFullWidgetAnimatableDataInterface: AnyObject {
    
}

final class StepsFullWidgetView: UIView, CTWidgetFullProtocol {
    var didChangeSelectedDate: ((Date) -> Void)?
    
    struct Model {
        let nowSteps: Int
        let goalSteps: Int?
    }
    
    weak var output: StepsFullWidgetOutput?
    var didTapCloseButton: (() -> Void)?
    
    private var presenter: StepsFullWidgetPresenterInterface?
    
    private lazy var topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.stepsWidget.closeArrow(), for: .normal)
        return button
    }()
    
    private lazy var lineProgressView: LineProgressView = {
        let view = LineProgressView()
        view.backgroundLineColor = R.color.stepsWidget.backgroundLine()
        view.colors = [
            R.color.stepsWidget.firstGradientColor(),
            R.color.stepsWidget.secondGradientColor()
        ]
        return view
    }()
    
    private lazy var mainButton: BasicButtonView = {
        BasicButtonView(
            type: .custom(
                CustomType(
                    image: CustomType.Image(
                        isPressImage: R.image.stepsWidget.goalPress(),
                        defaultImage: R.image.stepsWidget.goalDefault(),
                        inactiveImage: nil
                    ),
                    title: CustomType.Title(
                        isPressTitleColor: .white,
                        defaultTitleColor: .white
                    ),
                    backgroundColorInactive: nil,
                    backgroundColorDefault: R.color.stepsWidget.secondGradientColor(),
                    backgroundColorPress: R.color.stepsWidget.backgroundLine(),
                    gradientColors: nil,
                    borderColorInactive: nil,
                    borderColorDefault: R.color.stepsWidget.ringColor(),
                    borderColorPress: .white
                )
            )
        )
    }()
    
    private lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    private let connectAHView = ConnectAHView()
    
    var model: Model? {
        didSet {
            guard let model = model else { return }
            configureLabel(value: model.nowSteps, goal: model.goalSteps)
            lineProgressView.progress = CGFloat(model.nowSteps) / CGFloat(model.goalSteps ?? 1)
            lineProgressView.isHidden = model.goalSteps == nil
            mainButton.defaultTitle = model.goalSteps == nil
            ? " \(R.string.localizable.stepsWidgetSetDailyGoal())"
            : " \(R.string.localizable.stepsWidgetChangeDailyGoal())"
            mainButton.isPressTitle = model.goalSteps == nil
                ? " \(R.string.localizable.stepsWidgetSetDailyGoal())"
                : " \(R.string.localizable.stepsWidgetChangeDailyGoal())"
        }
    }
    
    var isConnectedAH = true {
        didSet {
            didChangeIsConnectedAH()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        presenter = StepsFullWidgetPresenter(view: self)
        presenter?.updateModel()
        setupView()
        didChangeIsConnectedAH()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        presenter?.updateModel()
    }
    
    private func setupView() {
        closeButton.addTarget(self, action: #selector(didTapBottomCloseButton), for: .touchUpInside)
        mainButton.addTarget(self, action: #selector(didTapMainButton), for: .touchUpInside)
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        addSubview(containerStack)
        
        containerStack.addArrangedSubview(topLabel)
        containerStack.addArrangedSubview(lineProgressView)
        containerStack.addArrangedSubview(mainButton)
        containerStack.addArrangedSubview(closeButton)
        containerStack.addArrangedSubview(connectAHView)
        
        containerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(32)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        lineProgressView.snp.makeConstraints { make in
            make.height.equalTo(12)
        }
        
        mainButton.aspectRatio(0.182)
        connectAHView.aspectRatio(0.182)
        
        closeButton.snp.makeConstraints { make in
//            make.height.width.equalTo(40)
        }
    }
    
    private func didChangeIsConnectedAH() {
        connectAHView.isHidden = isConnectedAH
        closeButton.isHidden = !isConnectedAH
    }
    
    private func configureLabel(value: Int, goal: Int?) {
        let leftColor = R.color.stepsWidget.secondGradientColor()
        let rightColor = R.color.stepsWidget.ringColor()
        let font = R.font.sfProRoundedBold(size: 22)
        let image = R.image.stepsWidget.foot()
        let leftAtributes: [StringSettings] = [.font(font), .color(leftColor)]
        let rightAtributes: [StringSettings] = [.font(font), .color(rightColor)]
        
        let string = goal != nil
            ? "\(R.string.localizable.diagramChartTypeStepsTitle()) \(value) / \(goal ?? 0)"
            : "\(R.string.localizable.diagramChartTypeStepsTitle()) \(value)"
        
        if goal == nil {
            topLabel.attributedText = string.attributedSring(
                [.init(worldIndex: [0, 1], attributes: leftAtributes)],
                image: .init(image: image, font: font, position: .left)
            )
        } else {
            topLabel.attributedText = string.attributedSring(
                [
                    .init(worldIndex: [0, 1], attributes: leftAtributes),
                    .init(worldIndex: [2, 3], attributes: rightAtributes)
                ],
                image: .init(image: image, font: font, position: .left)
            )
        }
    }
    
    @objc private func didTapBottomCloseButton(_ sender: UIButton) {
        Vibration.medium
            .vibrate()
        didTapCloseButton?()
    }
    
    @objc private func didTapMainButton(_ sender: UIButton) {
        output?.setGoal(self)
    }
}

extension StepsFullWidgetView: StepsFullWidgetInterface {
    func setModel(_ model: Model) {
        self.model = model
    }
}

extension StepsFullWidgetView: StepsFullWidgetAnimatableProtocol {
    func getBackgroundLinePath() -> CGPath? {
        return CGPath(ellipseIn: .zero, transform: .none)
    }
    
    func closeButtonFrame() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        return superview.getConvertedFrame(fromSubview: closeButton) ?? .zero
    }
    
    func getMainButtonFrame() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        return superview.getConvertedFrame(fromSubview: mainButton) ?? .zero
    }
    
    func getWidgetContainerFrame() -> CGRect {
        return self.frame
    }
    
    func getFrameForTopTitle() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        return superview.getConvertedFrame(fromSubview: topLabel) ?? .zero
    }
    
    func getProgressContainerFrame() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        return superview.getConvertedFrame(fromSubview: lineProgressView) ?? .zero
    }
    
    func getStraightLinePath() -> CGPath? {
        lineProgressView.getLineShape()
    }
    
    func getFlagFrame() -> CGRect {
        guard let superview = superview else {
            return .zero
        }
        return superview.getConvertedFrame(fromSubview: lineProgressView.imageView) ?? .zero
    }
    
    func getGradientControlPoints() -> (startPoint: CGPoint, endPoint: CGPoint) {
        return (lineProgressView.gradientLayer.startPoint, lineProgressView.gradientLayer.endPoint)
    }
}
