//
//  SearchTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.08.2022.
//

import UIKit

final class SearchTextField: UITextField {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.searchTextField.search()
        view.contentMode = .scaleAspectFill
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
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        leftViewMode = .whileEditing
        tintColor = R.color.burnedKcalTextField.separator()
        textColor = R.color.burnedKcalTextField.text()
        textAlignment = .center
        backgroundColor = .white
        font = R.font.sfProDisplaySemibold(size: 18)

        placeholder = "SEARCH FOOD"
        
        let view = UIView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-4)
            make.width.equalTo(imageView.snp.height)
        }
        
        leftView = view
    }
    
    private func textFieldInnerShadow() {
        let innerShadowLayer = CALayer()
        innerShadowLayer.frame = bounds
        innerShadowLayer.shadowPath = getShadowPath(rect: bounds).cgPath
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowColor = R.color.searchTextField.shadow()?.cgColor
        innerShadowLayer.shadowOffset = CGSize(width: 0, height: 0.5)
        innerShadowLayer.shadowOpacity = 1
        innerShadowLayer.shadowRadius = 2
        layer.addSublayer(innerShadowLayer)
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
    
    private func getPlaceholder(_ text: String) -> NSAttributedString {
        let image = R.image.searchTextField.search()!
        let imageStr = image.asAttributedString
        let attributedString = NSMutableAttributedString(attributedString: imageStr)
        attributedString.append(NSAttributedString(string: " \(text)"))
        
        return attributedString
    }
}
