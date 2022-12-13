//
//  ImageAndTitleVerticalView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.11.2022.
//

import UIKit

final class ImageAndTitleVerticalView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 11)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    init(_ image: UIImage?, color: UIColor?) {
        super.init(frame: .zero)
        self.imageView.image = image
        self.titleLabel.textColor = color
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ title: String) {
        titleLabel.text = title
    }
    
    private func setupView() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
