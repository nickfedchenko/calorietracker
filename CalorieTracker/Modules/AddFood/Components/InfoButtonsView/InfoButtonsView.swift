//
//  InfoButtonsView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.11.2022.
//

import UIKit

final class InfoButtonsView<ID: WithGetDataProtocol>: UIView {
    var completion: ((@escaping (InfoButtonView<ID>.InfoButtonType) -> Void) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 7.15
        return stack
    }()
    
    private let initModels: [InfoButtonView<ID>.InfoButtonType]
    
    init(_ models: [InfoButtonView<ID>.InfoButtonType]) {
        self.initModels = models
        super.init(frame: .zero)
        setupView()
        addSubviews()
        setupConstraints()
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
    }
    
    private func addSubviews() {
        addSubviews(stackView)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureStack() {
        initModels.forEach { type in
            let menuCellView = InfoButtonView<ID>()
            menuCellView.buttonType = type
            
            switch type {
            case .settings, .configurable:
                menuCellView.addTarget(self, action: #selector(didSelectedCell), for: .touchUpInside)
            default:
                break
            }
            
            menuCellView.snp.makeConstraints { make in
                make.height.equalTo(24)
                make.width.equalTo(38)
            }
            
            stackView.addArrangedSubview(menuCellView)
        }
    }
    
    @objc private func didSelectedCell(_ sender: UIControl) {
        guard let button = sender as? InfoButtonView<ID> else { return }
        
        completion? { type in
            button.buttonType = type
        }
    }
}
