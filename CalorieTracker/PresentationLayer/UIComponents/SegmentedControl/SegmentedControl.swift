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
    
    private var selectedButton: Button? {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                self.selectorView.frame = self.selectedButton?.superview?.frame ?? CGRect.zero
            } completion: { _ in
                self.selectorView.frame = self.selectedButton?.superview?.frame ?? CGRect.zero
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
        
        selectedButton = buttons.first
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
            make.edges.equalToSuperview()
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
