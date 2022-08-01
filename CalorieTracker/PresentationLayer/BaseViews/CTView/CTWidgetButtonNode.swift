//
//  CTWidgetButtonNode.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 25.07.2022.
//

import AsyncDisplayKit

class CTWidgetButtonNode: ASButtonNode {
    struct Shadow {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
        let shape: ShadowShape
    }
    
    enum ShadowShape {
        case circle
        case rectangle(radius: CGFloat)
    }
    
    private var shadows: [Shadow] = [
        .init(
            color: R.color.widgetShadowColorSecondaryLayer()!,
            opacity: 0.2,
            offset: .init(width: 0, height: 0.5),
            radius: 2,
            shape: .rectangle(radius: 16)
        ),
        .init(
            color: R.color.widgetShadowColorMainLayer()!,
            opacity: 0.25,
            offset: .init(width: 0, height: 4),
            radius: 10,
            shape: .rectangle(radius: 16)
        )
    ]
    
    struct CTConstants {
        let height: CGFloat
        let suggestedTopSafeAreaOffset: CGFloat
        let suggestedInterItemSpacing: CGFloat
        let suggestedSideInset: CGFloat
    }
    
    // MARK: - Public properties
    
    var constants: CTConstants {
        .init(
            height: configuration.height,
            suggestedTopSafeAreaOffset: configuration.suggestedTopSafeAreaOffset,
            suggestedInterItemSpacing: configuration.suggestedInterItemSpacing,
            suggestedSideInset: configuration.suggestedSideInset
        )
    }
    
    // MARK: - Private properties
    private var configuration: CTWidgetNodeConfiguration!
    private var isFirstDraw = true
    
    // MARK: - Init
    init(with configuration: CTWidgetNodeConfiguration) {
        super.init()
        automaticallyManagesSubnodes = true
        self.configuration = configuration
        setupView()
    }
    
    override func didLoad() {
        super.didLoad()
        setupCorners()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willEnterHierarchy() {
        super.willEnterHierarchy()
        guard isFirstDraw else { return }
        drawShadows()
        isFirstDraw = false
    }
    
    private func drawShadows() {
        shadows.forEach { addShadowLayer(shadow: $0) }
    }
    
    private func addShadowLayer(shadow: Shadow) {
        var path: UIBezierPath
        switch shadow.shape {
        case .circle:
            path = UIBezierPath(ovalIn: bounds)
        case .rectangle(let radius):
            path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
        }
        let shadowLayer = CALayer()
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
        shadowLayer.frame = bounds
        path.append(UIBezierPath(rect: CGRect(
            origin: CGPoint(
                x: bounds.origin.x - (shadow.radius + 10) / 2.0,
                y: bounds.origin.y - (shadow.radius + 10) / 2.0
            ),
            size: CGSize(
                width: bounds.width + shadow.radius + 20,
                height: bounds.height + shadow.radius + 20
            )
        )))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.fillRule = .evenOdd
        shadowLayer.mask = mask
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    // MARK: - Public methods
    
    func setTopOffset(_ offset: CGFloat) {
        configuration.setCustomTopOffset(offset)
    }
    
    func setSidesInset(_ inset: CGFloat) {
        configuration.setCustomSideInset(inset)
    }
    
    func setInteritemSpacing(_ spacing: CGFloat) {
        configuration.setCustomInterItemSpacing(spacing)
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        style.height = ASDimension(unit: .points, value: constants.height)
        style.minWidth = style.height
    }
    
    private func setupCorners() {
        cornerRadius = 16
        layer.cornerCurve = .continuous
    }
}
