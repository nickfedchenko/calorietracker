//
//  MenuCellTypeSecondView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.11.2022.
//

import UIKit

final class MenuCellTypeSecondView: UIControl {
    typealias CellModel = ContextMenuTypeSecondView.MenuCellViewModel
    
    private lazy var imageView: RoundedImageView = {
        let view = RoundedImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.isUserInteractionEnabled = false
        view.layer.borderWidth = 2
        view.contentMode = .center
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 18)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var firstDraw = true
    
    let model: CellModel
    
    private let isSelectedTextColor: UIColor? = R.color.addFood.menu.background()
    private var isNotSelectedTextColor: UIColor?
    
    var isSelectedCell = false {
        didSet {
            didChangeState()
        }
    }
    
    init(_ model: CellModel) {
        self.model = model
        super.init(frame: .zero)
        titleLabel.text = model.title
        isNotSelectedTextColor = model.color
        setupView()
        addSubviews()
        setupConstraints()
        didChangeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw else { return }
        layer.cornerRadius = bounds.height / 2.0
        firstDraw = false
    }
    
    private func setupView() {
        layer.cornerCurve = .circular
    }
    
    private func addSubviews() {
        addSubviews(imageView, titleLabel)
    }
    
    private func setupConstraints() {
        imageView.aspectRatio()
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.top.bottom.equalToSuperview().inset(4)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.top.bottom.trailing.equalToSuperview()
        }
    }
    
    private func didChangeState() {
        switch isSelectedCell {
        case true:
            backgroundColor = isNotSelectedTextColor
            titleLabel.textColor = isSelectedTextColor
            imageView.layer.borderColor = isSelectedTextColor?.cgColor
            imageView.image = R.image.addFood.menu.checkmark()
        case false:
            backgroundColor = .clear
            titleLabel.textColor = isNotSelectedTextColor
            imageView.layer.borderColor = isNotSelectedTextColor?.cgColor
            imageView.image = nil
        }
    }
}
