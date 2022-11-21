//
//  SearchTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.08.2022.
//

import UIKit

final class SearchTextField: InnerShadowTextField {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.searchTextField.search()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        innerShadowColor = R.color.searchTextField.shadow()
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
    
    private func getPlaceholder(_ text: String) -> NSAttributedString {
        let image = R.image.searchTextField.search()!
        let imageStr = image.asAttributedString
        let attributedString = NSMutableAttributedString(attributedString: imageStr)
        attributedString.append(NSAttributedString(string: " \(text)"))
        
        return attributedString
    }
}
