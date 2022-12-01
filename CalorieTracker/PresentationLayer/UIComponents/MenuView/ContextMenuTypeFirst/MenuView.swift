//
//  MenuView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 30.10.2022.
//

import UIKit

final class MenuView<ID: WithGetTitleProtocol & WithGetImageProtocol>: UIView {    
    var complition: ((ID) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()
    
    private var firstDraw = true
    private var zeroHeightAnchor: NSLayoutConstraint?
    private var zeroHeightAnchors: [NSLayoutConstraint] = []
    private var shadowLayer = CALayer()
    
    let model: [ID]
    
    init(_ model: [ID]) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        addSubviews()
        setupConstraints()
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw else { return }
        setupShadow()
        firstDraw = false
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
            return
        } else {
            UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseInOut) {
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
            UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseInOut) {
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
    }
    
    private func setupConstraints() {
        zeroHeightAnchor = self.heightAnchor.constraint(equalToConstant: 0)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
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
            zeroHeightAnchors.append(menuCellView.heightAnchor.constraint(equalToConstant: 0))
        }
    }
    
    private func setupShadow() {
        shadowLayer.frame = bounds
        shadowLayer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
        shadowLayer.addShadow(
            shadow: ShadowConst.secondShadow,
            rect: bounds,
            cornerRadius: layer.cornerRadius
        )
    }
    
    @objc private func didSelectedCell(_ sender: UIControl) {
        guard let view = sender as? MenuCellView<ID> else { return }
        stackView.arrangedSubviews.forEach {
            ($0 as? MenuCellView<ID>)?.isSelectedCell = false
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
        radius: 10
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.25,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2
    )
}
