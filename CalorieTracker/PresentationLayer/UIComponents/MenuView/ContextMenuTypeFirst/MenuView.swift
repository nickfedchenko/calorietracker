//
//  MenuView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

final class MenuView<ID: WithGetTitleProtocol
                        & WithGetImageProtocol
                        & WithGetDescriptionProtocol>: ViewWithShadow, MenuViewProtocol {
    var complition: ((ID) -> Void)?
    var didClose: (() -> Void)?
    
    let model: [ID]
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 22)
        label.textColor = UIColor(hex: "192621")
        label.text = R.string.localizable.addFoodCreate()
        label.alpha = shouldShowTitleLabel ? 1 : 0
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.createMeal.close(), for: .normal)
        button.tintColor = UIColor(hex: "7A948F")
        button.alpha = shouldShowTitleLabel ? 1 : 0
        button.addAction(
            UIAction { [weak self] _ in
                guard let self = self else { return }
                self.closeView(index: self.model.count - 1)
            },
            for: .touchUpInside
        )
        return button
    }()
    
    private var shouldShowTitleLabel: Bool
    init(_ model: [ID], shouldShowTitleLabel: Bool = true) {
        self.model = model
        self.shouldShowTitleLabel = shouldShowTitleLabel
        super.init([ShadowConst.firstShadow, ShadowConst.secondShadow])
        setupView()
        addSubviews()
        setupConstraints()
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func closeNotAnimate() {
        shadowLayer.isHidden = true
        isHidden = true
        stackView.arrangedSubviews.forEach {
            $0.layer.opacity = 0
            $0.isHidden = true
        }
    }
    
    func showAndCloseView(_ flag: Bool) {
        switch flag {
        case true:
            showView(index: 0)
        case false:
            closeView(index: model.count - 1)
        }
    }
    
    private func closeView(index: Int) {
        shadowLayer.isHidden = true
        if index == -1 {
            isHidden = true
            didClose?()
            return
        } else {
            UIView.animate(withDuration: 0.02, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[index].layer.opacity = 0
                self.stackView.arrangedSubviews[index].isHidden = true
            } completion: { _ in
                self.closeView(index: index - 1)
            }
        }
    }
    
    private func showView(index: Int) {
        shadowLayer.isHidden = true
        isHidden = false
        if index == model.count {
            UIView.animate(withDuration: 0.02, delay: 0, options: .curveEaseInOut) {
                self.shadowLayer.isHidden = false
            }
            return
        } else {
            UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[index].layer.opacity = 1
                self.stackView.arrangedSubviews[index].isHidden = false
            } completion: { _ in
                self.showView(index: index + 1)
            }
        }
    }
    
    private func setupView() {
        layer.insertSublayer(shadowLayer, at: 0)
        layer.cornerCurve = .continuous
        layer.cornerRadius = 22
        backgroundColor = R.color.addFood.menu.background()
    }
    
    private func addSubviews() {
        addSubviews(stackView)
        if shouldShowTitleLabel {
            addSubviews(title, closeButton)
        }
    }
    
    private func setupConstraints() {
        if shouldShowTitleLabel {
            title.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(32)
                make.top.equalToSuperview().offset(24)
            }
            
            closeButton.snp.makeConstraints { make in
                make.width.height.equalTo(40)
                make.trailing.equalToSuperview().inset(16)
                make.top.equalToSuperview().offset(16)
            }
        }
        
        stackView.snp.makeConstraints { make in
            if shouldShowTitleLabel {
                make.top.equalTo(title.snp.bottom).offset(28)
            } else {
                make.top.equalToSuperview().offset(12)
            }
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func configureStack() {
        model.forEach {
            let menuCellView = MenuCellView($0)
            menuCellView.addTarget(
                self,
                action: #selector(didSelectedCell),
                for: .touchUpInside
            )
            menuCellView.snp.makeConstraints { make in
                make.height.equalTo(64)
            }
            
            stackView.addArrangedSubview(menuCellView)
        }
    }
    
    @objc private func didSelectedCell(_ sender: UIControl) {
        Vibration.selection.vibrate()
        guard let view = sender as? MenuCellView<ID> else { return }
        stackView.arrangedSubviews.forEach {
            ($0 as? MenuCellView<ID>)?.isSelectedCell = false
        }
        view.isSelectedCell = true
        complition?(view.model)
        showAndCloseView(false)
    }
    
    func selectCell(at index: Int) {
        guard index < stackView.arrangedSubviews.count else { return }
        guard let control = stackView.arrangedSubviews[index] as? UIControl else { return }
        didSelectedCell(control)
    }
}

private struct ShadowConst {
    static let firstShadow = Shadow(
        color: R.color.addFood.menu.firstShadow() ?? .black,
        opacity: 0.2,
        offset: CGSize(width: 0, height: 4),
        radius: 10,
        spread: 0
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.25,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2,
        spread: 0
    )
}
