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
        let spasing = constrainedSize.min.height / 5.33
        
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets(
                top: spasing,
                left: spasing,
                bottom: spasing,
                right: spasing
            ),
            child: scanImageNode
        )
    }
    
    private func setupView() {
        automaticallyManagesSubnodes = true
        backgroundColor = .white
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        addTarget(
            self,
            action: #selector(didNotSelectedButton),
            forControlEvents: .touchUpInside
        )
        addTarget(
            self,
            action: #selector(didSelectedButton),
            forControlEvents: .touchDown
        )
    }
    
    @objc private func didSelectedButton() {
        scanImageNode.image = R.image.scanButton.buttonPressed()
    }
    
    @objc private func didNotSelectedButton() {
        scanImageNode.image = R.image.scanButton.buttonNotPressed()
    }
}
