//
//  ContextMenuTypeSecondView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 03.11.2022.
//

import UIKit

final class ContextMenuTypeSecondView<ID: WithGetDataProtocol>: ViewWithShadow, MenuViewProtocol {
    var didClose: (() -> Void)?
    var complition: ((ID) -> Void)?
    var defaultSelectedIndex = 0
    
    let model: [ID]
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private var zeroHeightAnchor: NSLayoutConstraint?
    private var zeroHeightAnchors: [NSLayoutConstraint] = []
    
    init(_ model: [ID], selectedIndex: Int = 0) {
        self.model = model
        self.defaultSelectedIndex = selectedIndex
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
            UIView.animate(withDuration: 0.02, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[index].layer.opacity = 1
                self.stackView.arrangedSubviews[index].isHidden = false
            } completion: { _ in
                self.showView(index: index + 1)
            }
        }
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 22
        backgroundColor = .white
    }
    
    private func addSubviews() {
        addSubviews(stackView)
    }
    
    private func setupConstraints() {
        zeroHeightAnchor = self.heightAnchor.constraint(equalToConstant: 0)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
    }
    
    private func configureStack() {
        model.enumerated().forEach { index, model in
            let menuCellView = MenuCellTypeSecondView(model)
            menuCellView.addTarget(self, action: #selector(didSelectedCell), for: .touchUpInside)
            menuCellView.snp.makeConstraints { make in
                make.height.equalTo(32)
            }
            if index == defaultSelectedIndex {
                menuCellView.isSelectedCell = true
            }
            stackView.addArrangedSubview(menuCellView)
            zeroHeightAnchors.append(menuCellView.heightAnchor.constraint(equalToConstant: 0))
        }
    }
    
    @objc private func didSelectedCell(_ sender: UIControl) {
        Vibration.selection.vibrate()
        guard let view = sender as? MenuCellTypeSecondView<ID> else { return }
        stackView.arrangedSubviews.forEach {
            ($0 as? MenuCellTypeSecondView<ID>)?.isSelectedCell = false
        }
        view.isSelectedCell = true
        complition?(view.model)
        showAndCloseView(false)
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
