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
    private var firstDraw = true
    
    var selectedButton: Button? {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                self.selectorView.frame = self.selectedButton?.superview?.frame ?? CGRect.zero
            }
        }
    }
    
    private lazy var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.cornerCurve = .circular
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
        guard firstDraw, let button = buttons.first, button.frame != .zero else { return }
        selectedButton = buttons.first
        setupShadow()
        firstDraw = false
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
                make.leading.trailing.equalToSuperview().inset(25.5)
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
    }
    
    private func setupShadow() {
        selectorView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        selectorView.layer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: selectorView.bounds,
            cornerRadius: 8
        )
        selectorView.layer.addShadow(
            shadow: ShadowConst.secondShadow,
            rect: selectorView.bounds,
            cornerRadius: 8
        )
    }
    
    @objc private func didTapSegmentedButton(_ sender: UIButton) {
        guard let button = sender as? Button else { return }
        buttons.forEach { $0.isSelected = false }
        button.isSelected = true
        
        selectedButton = button
        onSegmentChanged?(button.model)
    }
}

private struct ShadowConst {
    static let firstShadow = Shadow(
        color: R.color.addFood.menu.firstShadow() ?? .black,
        opacity: 0.2,
        offset: CGSize(width: 0, height: 4),
        radius: 10
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.25,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2
    )
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
