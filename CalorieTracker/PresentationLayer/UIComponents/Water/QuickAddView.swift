//
//  QuickAddView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.09.2022.
//

import UIKit

final class QuickAddView: ViewWithShadow {
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = R.color.quickAdd.background()
        label.font = R.font.sfProDisplaySemibold(size: 16.fontScale())
        return label
    }()
    
    var isEdit = false {
        didSet {
            configureView(model)
        }
    }
    
    var model: QuickAddModel = .init(type: .add, value: nil) {
        didSet {
            configureView(model)
        }
    }
    
    init() {
        super.init(Const.shadows)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func configureView(_ model: QuickAddModel) {
        let value = BAMeasurement(Double(model.value ?? 0), .liquid, isMetric: true).string

        imageView.image = model.type.getImage()
        imageView.contentMode = .scaleAspectFill
        backgroundColor = .white
        label.isHidden = false
        layer.borderColor = isEdit
            ? R.color.quickAdd.background()?.cgColor
            : R.color.quickAdd.border()?.cgColor
        
        switch model.type {
        case .add, .edit:
            backgroundColor = R.color.quickAdd.background()
            layer.borderColor = R.color.quickAdd.borderAdd()?.cgColor
            label.isHidden = true
            imageView.contentMode = .center
        case .cup, .bottle, .bottleSport, .jug:
            label.text = "+\(value)"
        }
    }
}

extension QuickAddView {
    struct Const {
        static let shadows: [Shadow] = [
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
    }
}
