//
//  BasicButtonView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.08.2022.
//

import AsyncDisplayKit

final class BasicButtonView: UIControl {
    private let buttonNode: BasicButtonNode
    
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
}

extension BasicButtonView {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        buttonNode.beginTracking(with: touch, with: event)
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        buttonNode.endTracking(with: touch, with: event)
    }
}
