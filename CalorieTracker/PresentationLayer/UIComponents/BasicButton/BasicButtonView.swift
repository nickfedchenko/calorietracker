//
//  BasicButtonView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import AsyncDisplayKit

final class BasicButtonView: UIControl {
    private let buttonNode: BasicButtonNode
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.4)
        return view
    }()
    
    var isPressTitle: String? {
        get { buttonNode.isPressTitle }
        set { buttonNode.isPressTitle = newValue }
    }
    var defaultTitle: String? {
        get { buttonNode.defaultTitle }
        set { buttonNode.defaultTitle = newValue }
    }
    
    var active: Bool = true {
        didSet {
            buttonNode.active = active
            self.isEnabled = active
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            switch buttonNode.type {
            case .save:
                if isEnabled {
                    makeEnabled()
                } else {
                    makeDisabled()
                }
            default:
                super.isEnabled = isEnabled
            }
        }
    }
    
    init(type: BasicButtonType) {
        buttonNode = BasicButtonNode(
            type: type,
            with: CTWidgetNodeConfiguration(type: .custom)
        )
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateNode(type: BasicButtonType) {
        buttonNode.updateType(type: type)
    }

    private func setupView() {
        addSubview(buttonNode.view)
        buttonNode.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func makeDisabled() {
        alpha = 0.3
    }
    
    private func makeEnabled() {
        alpha = 1
    }
}

extension BasicButtonView {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        buttonNode.beginTracking(with: touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        buttonNode.endTracking(with: touch, with: event)
    }
}
