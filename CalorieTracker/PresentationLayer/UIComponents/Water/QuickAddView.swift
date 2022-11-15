//
//  QuickAddView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.09.2022.
//

import UIKit

final class QuickAddView: UIView {
    struct Shadow {
        let color: UIColor
        let opacity: Float
        let offset: CGSize
        let radius: CGFloat
    }
    
    enum TypeQuickAdd: Equatable {
        case add
        case edit
        case cup(Int)
        case bottle(Int)
        case bottleSport(Int)
        case jug(Int)
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = R.color.quickAdd.background()
        label.font = R.font.sfProDisplaySemibold(size: 16)
        return label
    }()
    
    private var isFirstDraw = true
    private var shadows: [Shadow] = [
        .init(
            color: R.color.quickAdd.shadowFirst()!,
            opacity: 0.1,
            offset: .init(width: 0, height: 0.5),
            radius: 2
        ),
        .init(
            color: R.color.quickAdd.shadowSecond()!,
            opacity: 0.1,
            offset: .init(width: 0, height: 4),
            radius: 16
        )
    ]
    
    var isEdit = false {
        didSet {
            configureView(typeQuickAdd)
        }
    }
    var typeQuickAdd: TypeQuickAdd = .add {
        didSet {
            configureView(typeQuickAdd)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureView(.add)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard isFirstDraw else { return }
        drawShadows()
        isFirstDraw = false
    }
    
    private func setupView() {
        layer.borderWidth = 1
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        addSubview(imageView)
        addSubview(label)
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.bottom).offset(4)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureView(_ type: TypeQuickAdd) {
        imageView.image = getImage(type)
        imageView.contentMode = .scaleAspectFill
        backgroundColor = .white
        label.isHidden = false
        layer.borderColor = isEdit
        ? R.color.quickAdd.background()?.cgColor
        : R.color.quickAdd.border()?.cgColor
        switch type {
        case .add, .edit:
            backgroundColor = R.color.quickAdd.background()
            layer.borderColor = R.color.quickAdd.borderAdd()?.cgColor
            label.isHidden = true
            imageView.contentMode = .center
        case .cup(let value):
            label.text = "+\(value)ml"
        case .bottle(let value):
            label.text = "+\(value)ml"
        case .bottleSport(let value):
            label.text = "+\(value)ml"
        case .jug(let value):
            label.text = "+\(value)ml"
        }
    }
    
    private func getImage(_ type: TypeQuickAdd) -> UIImage? {
        switch type {
        case .add:
            return R.image.quickAdd.add()
        case .cup:
            return R.image.quickAdd.cup()
        case .bottle:
            return R.image.quickAdd.bottle()
        case .bottleSport:
            return R.image.quickAdd.bottleSport()
        case .jug:
            return R.image.quickAdd.jug()
        case .edit:
            return R.image.quickAdd.edit()
        }
    }
    
    private func drawShadows() {
        shadows.forEach { addShadowLayer(shadow: $0) }
    }
    private func extractedFunc(_ shadowLayer: CALayer, _ path: UIBezierPath, _ shadow: Shadow) {
        shadowLayer.shadowPath = path.cgPath
        shadowLayer.shadowColor = shadow.color.cgColor
        shadowLayer.shadowOpacity = shadow.opacity
        shadowLayer.shadowOffset = shadow.offset
        shadowLayer.shadowRadius = shadow.radius
    }
    
    private func addShadowLayer(shadow: Shadow) {
        let path = UIBezierPath(roundedRect: imageView.bounds, cornerRadius: 16)
   
        let shadowLayer = CALayer()
        extractedFunc(shadowLayer, path, shadow)
        shadowLayer.frame = imageView.bounds
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
}
