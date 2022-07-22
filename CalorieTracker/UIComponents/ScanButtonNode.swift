//
//  ScanButtonNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 22.07.2022.
//

import AsyncDisplayKit

final class ScanButtonNode: ASButtonNode {
    private lazy var scanImageNode: ASImageNode = {
        let node = ASImageNode()
        node.image = R.image.scanButton.buttonNotPressed()
        return node
    }()
    
    override init() {
        super.init()
        setupView()
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
        layer.masksToBounds = true
        
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
