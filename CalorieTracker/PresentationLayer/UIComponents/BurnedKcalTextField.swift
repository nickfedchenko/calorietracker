//
//  BurnedKcalTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 20.08.2022.
//

import UIKit

final class BurnedKcalTextField: UIView {
    var didTapRightButton: ((UIButton) -> Void)?
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.textColor = R.color.burnedKcalTextField.text()
        view.tintColor = R.color.burnedKcalTextField.separator()
        view.layer.cornerRadius = 16
        view.layer.cornerCurve = .continuous
        view.layer.borderWidth = 1
        view.layer.borderColor = R.color.burnedKcalTextField.background()?.cgColor
        view.font = R.font.sfProDisplaySemibold(size: 28)
        view.textAlignment = .right
        view.rightViewMode = .always
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 28)
        label.textColor = R.color.burnedKcalTextField.kcal()
        label.text = "kcal"
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = R.image.burnedKcalTextField.burned()
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let view = UIButton()
        view.setImage(R.image.burnedKcalTextField.chevron(), for: .normal)
        return view
    }()
    
    private var isFirstDraw = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw else { return }
        textFieldInnerShadow()
        isFirstDraw = false
    }
    
    private func setupView() {
        backgroundColor = R.color.burnedKcalTextField.background()
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        let view = UIView()
        view.addSubview(rightLabel)
        rightLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-35.5)
            make.centerY.equalToSuperview()
        }
        textField.rightView = view
        rightButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        addSubviews([imageView, textField, rightButton])
        
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp.height)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(rightButton.snp.height)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(imageView.snp.trailing)
            make.trailing.equalTo(rightButton.snp.leading)
        }
    }
    
    private func textFieldInnerShadow() {
        let innerShadowLayer = CALayer()
        innerShadowLayer.frame = bounds
        innerShadowLayer.shadowPath = getShadowPath(rect: textField.bounds).cgPath
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowColor = R.color.waterSlider.backgroundShadow()?.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        innerShadowLayer.shadowOpacity = 1
        innerShadowLayer.shadowRadius = 8
        textField.layer.addSublayer(innerShadowLayer)
    }
    
    private func getShadowPath(rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath(
            roundedRect: rect.insetBy(dx: -8, dy: -8),
            cornerRadius: 16
        )
        let innerPart = UIBezierPath(
            roundedRect: rect,
            cornerRadius: 16
        ).reversing()
        path.append(innerPart)
        
        return path
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        didTapRightButton?(sender)
    }
}
