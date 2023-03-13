//
//  SegmentedControl.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.08.2022.
//

import UIKit

final class SegmentedControl<ID: Equatable>: UIView {
    typealias Button = SegmentedButton<ID>
    
    var buttons: [Button]
    private var firstDraw = true
    
    private(set) var selectedButton: Button? {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut) {
                self.selectorView.frame = {
                    guard let selectedButtonFrame = self.selectedButton?.superview?.frame else {
                        return .zero
                    }
                    print("selected button frame \(selectedButtonFrame)")
                    let frame = self.stack.convert(selectedButtonFrame, to: self)
                    print("selection frame is \(self.stack.convert(selectedButtonFrame, to: self))")
                    return self.stack.convert(selectedButtonFrame, to: self)
                }()
            }
        }
    }
    
    private lazy var selectorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 1
        return stack
    }()
    
    private var flag = true
    
    var selectedButtonType: ID?
    var onSegmentChanged: ((Button.Model) -> Void)?
    var textNormalColor: UIColor? = .black
    var textSelectedColor: UIColor? = .green
    var font: UIFont? = R.font.sfProTextSemibold(size: 16) {
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
        set {
            selectorView.layer.cornerRadius = newValue
            stack.arrangedSubviews.forEach { $0.layer.cornerRadius = newValue }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
        guard firstDraw,
              let button = getSelectedButton(selectedButtonType),
              button.frame != .zero else { return }
        button.isSelected = true
        selectedButton = button
        setupShadow()
        firstDraw = false
    }
    
    private func getSelectedButton(_ type: ID?) -> Button? {
        return buttons.first(where: { $0.model.id == type })
    }

    private func setupViews() {
        layer.cornerRadius = 8
        layer.cornerCurve = .circular

        buttons.forEach { button in
            let view = UIView()
            view.addSubview(button)
            button.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.lessThanOrEqualToSuperview().inset(26.5)
                make.center.equalToSuperview()
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
            shadow: ShadowConst.secondShadow,
            rect: selectorView.bounds,
            cornerRadius: selectorRadius
        )
        selectorView.layer.addShadow(
            shadow: ShadowConst.firstShadow,
            rect: selectorView.bounds,
            cornerRadius: selectorRadius
        )
    }
    
    @objc private func didTapSegmentedButton(_ sender: UIButton) {
        Vibration.selection.vibrate()
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
        radius: 10,
        spread: 0
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.25,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2,
        spread: 0
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
            return R.string.localizable.weightWidgetFullSegmentWeek()
        case .months:
            return R.string.localizable.weightWidgetFullSegmentMonth()
        case .twoMonths:
            return R.string.localizable.weightWidgetFullSegment2months()
        case .threeMonths:
            return R.string.localizable.weightWidgetFullSegment3months()
        case .sixMonths:
            return R.string.localizable.weightWidgetFullSegmentHalfYear()
        case .year:
            return R.string.localizable.weightWidgetFullSegmentYear()
        case .allTheTime:
            return R.string.localizable.weightWidgetFullSegmentAlltime()
        }
    }
}
