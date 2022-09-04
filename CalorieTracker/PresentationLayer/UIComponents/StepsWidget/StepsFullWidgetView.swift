//
//  StepsFullWidgetView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.08.2022.
//

import UIKit

final class StepsFullWidgetView: UIView {
    struct Model {
        let nowSteps: Int
        let goalSteps: Int?
    }
    
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
            mainButton.defaultTitle = model.goalSteps == nil ? " SET DAILY GOAL" :" CHANGE DAILY GOAL"
            mainButton.isPressTitle = model.goalSteps == nil ? " SET DAILY GOAL" :" CHANGE DAILY GOAL"
        }
    }
    
    var isConnectedAH = true {
        didSet {
            didChangeIsConnectedAH()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        didChangeIsConnectedAH()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
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
        
        mainButton.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(40)
        }
        
        connectAHView.snp.makeConstraints { make in
            make.height.equalTo(64)
        }
    }
    
    private func didChangeIsConnectedAH() {
        connectAHView.isHidden = isConnectedAH
        closeButton.isHidden = !isConnectedAH
    }
    
    private func configureLabel(value: Int, goal: Int?) {
        let stepString = getAttributedStringWithImage(
            image: R.image.stepsWidget.foot(),
            attributedString: getAttributedString(
                string: "  STEPS  ",
                size: 22,
                weight: .bold,
                color: R.color.stepsWidget.secondGradientColor()
            )
        )
        
        let valueString = getAttributedString(
            string: "\(value)",
            size: 22,
            weight: .heavy,
            color: R.color.stepsWidget.secondGradientColor()
        )
        
        var goalString: NSAttributedString?
        
        if let goal = goal {
            goalString = getAttributedString(
                string: " / \(goal)",
                size: 22,
                weight: .bold,
                color: R.color.stepsWidget.ringColor()
            )
        }
        
        let fullString = NSMutableAttributedString(attributedString: stepString)
        fullString.append(valueString)
        fullString.append(goalString ?? NSAttributedString())
        
        topLabel.attributedText = fullString
    }
    
    private func getAttributedStringWithImage(image: UIImage?,
                                              attributedString: NSAttributedString) -> NSAttributedString {
        guard let image = image else { return NSMutableAttributedString() }
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        imageAttachment.bounds = CGRect(
            x: 0,
            y: (UIFont.roundedFont(
                ofSize: 22,
                weight: .bold
            ).capHeight - image.size.height).rounded() / 2,
            width: image.size.width,
            height: image.size.height
        )
        let imageString = NSAttributedString(attachment: imageAttachment)
        let fullString = NSMutableAttributedString(attributedString: imageString)
        fullString.append(attributedString)
        
        return fullString
    }
    
    private func getAttributedString(string: String,
                                     size: CGFloat,
                                     weight: UIFont.Weight,
                                     color: UIColor?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttributes(
            [
                .foregroundColor: color ?? .black,
                .font: UIFont.roundedFont(ofSize: size, weight: weight)
            ],
            range: NSRange(location: 0, length: string.count)
        )
        
        return attributedString
    }
    
    @objc private func didTapCloseButton(_ sender: UIButton) {
        
    }
    
    @objc private func didTapMainButton(_ sender: UIButton) {
        
    }
}
