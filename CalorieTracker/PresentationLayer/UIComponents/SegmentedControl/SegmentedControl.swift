//
//  SegmentedControl.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.08.2022.
//

import UIKit

final class SegmentedControl<ID>: UIView {
    typealias Button = SegmentedButton<ID>
    
    private let buttons: [Button]
    
    var selectedButton: Button? {
        didSet {
            let rect = self.selectedButton?.superview?.frame ?? CGRect.zero
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.selectorView.frame = CGRect(
                    x: (self.insets?.left ?? 0) + rect.origin.x,
                    y: (self.insets?.top ?? 0) + rect.origin.y,
                    width: rect.width,
                    height: rect.height
                )
            }
        }
    }
    
    private lazy var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .circular
        view.layer.shadowRadius = 18
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .init(width: 0, height: 4)
        
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    private var flag = true
    
    var onSegmentChanged: ((Button.Model) -> Void)?
    var textNormalColor: UIColor? = .black
    var textSelectedColor: UIColor? = .green
    var font: UIFont? = R.font.sfProDisplaySemibold(size: 16) {
        didSet {
            buttons.forEach { button in
                button.font = font
            }
        }
    }
    var insets: UIEdgeInsets? {
        didSet {
            guard let insets = insets else { return }
            stack.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(insets.top)
                make.bottom.equalToSuperview().offset(-insets.bottom)
                make.leading.equalToSuperview().offset(insets.left)
                make.trailing.equalToSuperview().offset(-insets.right)
            }
        }
    }
    
    var distribution: UIStackView.Distribution {
        get { stack.distribution }
        set { stack.distribution = newValue }
    }
    var selectorRadius: CGFloat {
        get { selectorView.layer.cornerRadius }
        set { selectorView.layer.cornerRadius = newValue }
    }
    
    init(_ buttons: [Button.Model]) {
        self.buttons = buttons.map(Button.init)
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = 8
        layer.cornerCurve = .circular
        
        buttons.first?.isSelected = true
        buttons.forEach { button in
            let view = UIView()
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview().inset(10.5)
            }
            stack.addArrangedSubview(view)
            button.addTarget(
                self,
                action: #selector(didTapSegmentedButton),
                for: .touchUpInside
            )
        }
    }
    
    private func setupConstraints() {
        addSubviews([selectorView, stack])
        
        stack.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        selectorView.snp.makeConstraints { make in
            make.edges.equalTo(stack.arrangedSubviews.first ?? stack)
        }
    }
    
    @objc private func didTapSegmentedButton(_ sender: UIButton) {
        guard let button = sender as? Button else { return }
        buttons.forEach { $0.isSelected = false }
        button.isSelected = true
        
        selectedButton = button
        onSegmentChanged?(button.model)
    }
}

enum HistoryHeaderButtonType {
    case weak
    case months
    case twoMonths
    case threeMonths
    case sixMonths
    case year
    case allTheTime
    
    func getTitle() -> String {
        switch self {
        case .weak:
            return NSLocalizedString("Неделя", comment: "")
        case .months:
            return NSLocalizedString("Месяц", comment: "")
        case .twoMonths:
            return NSLocalizedString("2 месяца", comment: "")
        case .threeMonths:
            return NSLocalizedString("3 месяца", comment: "")
        case .sixMonths:
            return NSLocalizedString("Полгода", comment: "")
        case .year:
            return NSLocalizedString("Год", comment: "")
        case .allTheTime:
            return NSLocalizedString("Все время", comment: "")
        }
    }
}
