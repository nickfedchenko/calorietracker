//
//  NoteWidgetNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.07.2022.
//

import AsyncDisplayKit

final class NoteWidgetNode: CTWidgetNode {
    private lazy var lastNodeView: LastNoteView = .init(frame: .zero)
    
    private lazy var imageNode: ASImageNode = {
        let node = ASImageNode()
        node.contentMode = UIView.ContentMode.scaleAspectFit
        node.image = R.image.noteWidgetNode.notePlug()
        return node
    }()
    
    private lazy var lastNoteNode: ASDisplayNode = {
        let node = ASDisplayNode { () -> UIView in
            return self.lastNodeView
        }
        
        return node
    }()
    
    var model: LastNoteView.Model? {
        didSet {
            guard let model = model else { return }
            lastNodeView.configure(model)
            transitionLayout(withAnimation: true, shouldMeasureAsync: false)
        }
    }
    
    override var widgetType: WidgetContainerViewController.WidgetType { .notes }
    
    override init(with configuration: CTWidgetNodeConfiguration) {
        super.init(with: configuration)
        setupNode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(
            insets: UIEdgeInsets.zero,
            child: model == nil ? imageNode : lastNoteNode
        )
    }
    
    private func setupNode() {
        backgroundColor = R.color.noteWidgetNode.background()
    }
}
