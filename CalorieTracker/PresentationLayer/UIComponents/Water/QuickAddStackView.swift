//
//  QuickAddStackView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.09.2022.
//

import UIKit

final class QuickAddStackView: UIView {
    private let containers = [
        UIView(),
        UIView(),
        UIView(),
        UIView()
    ]
    
    private let views = [
        QuickAddView(),
        QuickAddView(),
        QuickAddView(),
        QuickAddView()
    ]
    
    var didTapQuickAdd: ((Int) -> Void)?
    var didTapEdit: ((@escaping (QuickAddModel) -> Void) -> Void)?
    
    var isEdit = false {
        didSet {
            configureView()
        }
    }
    
    var viewsType: [QuickAddModel] {
        get { views.map { $0.model } }
        set {
            zip(views, newValue).forEach { $0.0.model = $0.1 }
            configureView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        addSubview(stack)
        stack.addArrangedSubviews(containers)
        
        zip(containers, views).forEach {
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
            $0.0.addSubview($0.1)
            $0.1.addGestureRecognizer(gestureRecognizer)
            $0.1.snp.makeConstraints { make in
                make.width.equalTo(self.snp.height)
                make.bottom.top.centerX.equalToSuperview()
            }
        }
        
        stack.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureView() {
        let cnv = zip(containers, views)
        
        switch isEdit {
        case true:
            cnv.forEach {
                $0.0.isHidden = false
                $0.1.model = $0.1.model.type == .add
                ? .init(type: .edit, value: nil)
                : $0.1.model
                $0.1.isEdit = true
            }
        case false:
            cnv.forEach {
                $0.1.model = $0.1.model.type == .edit
                ? .init(type: .add, value: nil)
                : $0.1.model
                $0.0.isHidden = $0.1.model.type == .add
                $0.1.isEdit = false
            }
            
            containers.last?.isHidden = true
        }
    }
    
    @objc private func didTapView(_ sender: UIGestureRecognizer) {
        Vibration.selection.vibrate()
        guard let view = sender.view as? QuickAddView else { return }
        if isEdit {
            didTapEdit? { model in
                view.model = model
            }
        } else {
            didTapQuickAdd?(view.model.value ?? 0)
            RateRequestManager.increment(for: .addWater)
        }
    }
}
