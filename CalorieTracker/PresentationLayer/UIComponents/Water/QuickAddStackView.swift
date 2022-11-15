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
    
    var isEdit = false {
        didSet {
            configureView()
        }
    }
    
    var viewsType: [QuickAddView.TypeQuickAdd] {
        get { views.map { $0.typeQuickAdd } }
        set {
            zip(views, newValue).forEach { $0.0.typeQuickAdd = $0.1 }
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
                $0.1.typeQuickAdd = $0.1.typeQuickAdd == .add
                ? .edit
                : $0.1.typeQuickAdd
                $0.1.isEdit = true
            }
        case false:
            cnv.forEach {
                $0.1.typeQuickAdd = $0.1.typeQuickAdd == .edit
                ? .add
                : $0.1.typeQuickAdd
                $0.0.isHidden = $0.1.typeQuickAdd == .add
                $0.1.isEdit = false
            }
            containers.last?.isHidden = false
        }
    }
    
    @objc private func didTapView(_ sender: UIGestureRecognizer) {
        guard let view = sender.view as? QuickAddView else { return }
        if isEdit {
            // change QuickAddView
            view.typeQuickAdd = .bottle(300)
        } else {
            switch view.typeQuickAdd {
            case .add, .edit:
                break
            case .cup(let value):
                didTapQuickAdd?(value)
            case .bottle(let value):
                didTapQuickAdd?(value)
            case .bottleSport(let value):
                didTapQuickAdd?(value)
            case .jug(let value):
                didTapQuickAdd?(value)
            }
        }
    }
}
