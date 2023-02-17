//
//  ScanButtonNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.07.2022.
//

import AsyncDisplayKit

final class ScanButtonNode: CTWidgetButtonNode {
    private lazy var scanImageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.scanButton.buttonNotPressed()
        node.isUserInteractionEnabled = false
        node.contentMode = .center
        return node
    }()
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            ),
            child: scanImageNode
        )
    }
    
    private func setupView() {
        automaticallyManagesSubnodes = true
        isUserInteractionEnabled = true
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
    }
}

// MARK: - Touch

extension ScanButtonNode {
    override func beginTracking(with touch: UITouch, with touchEvent: UIEvent?) -> Bool {
        scanImageNode.image = R.image.scanButton.buttonPressed()
        return true
    }
    
    override func endTracking(with touch: UITouch?, with touchEvent: UIEvent?) {
        scanImageNode.image = R.image.scanButton.buttonNotPressed()
    }
}
