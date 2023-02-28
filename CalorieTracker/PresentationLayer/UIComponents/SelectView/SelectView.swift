//
//  SelectView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

final class SelectView<ID: WithGetTitleProtocol>: UIView {
    var selectedCellType: ID? { getSelectedCell()?.id }
    var didSelectedCell: ((ID, Bool) -> Void)?
    
    var height: CGFloat? {
        didSet {
            configureHeightConstraint()
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var backgroundView: ViewWithShadow = {
        let view = ViewWithShadow([
            ShadowConst.firstShadow,
            ShadowConst.secondShadow
        ])
        view.backgroundColor = .white.withAlphaComponent(0.9)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 22
        return view
    }()
    
    var isCollapsed = false
    
    private let models: [ID]
    
    init(_ models: [ID], shouldHideAtStartup: Bool = false) {
        self.models = models
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        configureStack()
        if shouldHideAtStartup {
            cellDidTapped(stackView.arrangedSubviews[0] as! UIControl)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collapse() {
        guard !isCollapsed else {
            if let type = selectedCellType {
                didSelectedCell?(type, true)
            }
            show(0)
            return
        }
        guard let selectedCell = getSelectedCell() else { return }

        stackView.arrangedSubviews.forEach {
            if let anyCell = $0 as? SelectViewCell<ID> {
                anyCell.isSelectedCell = anyCell.id.getTitle(.long) == selectedCell.id.getTitle(.long)
            }
        }
        
        didSelectedCell?(selectedCell.id, false)
        close(models.count)
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 22
        isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        addSubviews(backgroundView, stackView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(-6)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func configureStack() {
        print(models)
        models.forEach {
            let cell = SelectViewCell($0)
            cell.addTarget(self, action: #selector(cellDidTapped), for: .touchUpInside)
            stackView.addArrangedSubview(cell)
        }
    }
    
    private func configureHeightConstraint() {
        guard let height = height else { return }
        stackView.arrangedSubviews.forEach {
            $0.snp.remakeConstraints { make in
                make.height.equalTo(height)
            }
        }
    }
    
    private func close(_ index: Int) {
        isCollapsed = true
        backgroundView.clipsToBounds = true
        if index == -1 {
            backgroundView.isHidden = true
            return
        } else if let selectedIndex = getSelectedCellIndex(), index == selectedIndex {
            self.close(index - 1)
        } else {
            UIView.animate(withDuration: 0.02, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[safe: index]?.layer.opacity = 0
                self.stackView.arrangedSubviews[safe: index]?.isHidden = true
            } completion: { _ in
                self.close(index - 1)
            }
        }
    }
    
    private func show(_ index: Int) {
        isCollapsed = false
        backgroundView.isHidden = false
        if index == models.count {
            backgroundView.clipsToBounds = false
            return
        } else if let selectedIndex = getSelectedCellIndex(), index == selectedIndex {
            self.show(index + 1)
        } else {
            UIView.animate(withDuration: 0.02, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[safe: index]?.layer.opacity = 1
                self.stackView.arrangedSubviews[safe: index]?.isHidden = false
            } completion: { _ in
                self.show(index + 1)
            }
        }
    }
    
    private func getSelectedCell() -> SelectViewCell<ID>? {
        stackView.arrangedSubviews
            .compactMap { $0 as? SelectViewCell<ID> }
            .first(where: { $0.isSelectedCell })
    }
    
    private func getSelectedCellIndex() -> Int? {
        stackView.arrangedSubviews
            .enumerated()
            .first(where: { ($0.element as? SelectViewCell<ID>)?.isSelectedCell ?? false })?
            .offset
    }
    
    @objc func cellDidTapped(_ sender: UIControl) {
        Vibration.selection.vibrate()
        guard !isCollapsed else {
            if let type = selectedCellType {
                didSelectedCell?(type, true)
            }
            show(0)
            return
        }
        guard let selectedCell = sender as? SelectViewCell<ID> else { return }

        stackView.arrangedSubviews.forEach {
            if let anyCell = $0 as? SelectViewCell<ID> {
                anyCell.isSelectedCell = anyCell.id.getTitle(.long) == selectedCell.id.getTitle(.long)
            }
        }
        
        didSelectedCell?(selectedCell.id, false)
        close(models.count)
    }
}

private struct ShadowConst {
    static let firstShadow = Shadow(
        color: R.color.addFood.menu.firstShadow() ?? .black,
        opacity: 0.1,
        offset: CGSize(width: 0, height: 4),
        radius: 10
    )
    static let secondShadow = Shadow(
        color: R.color.addFood.menu.secondShadow() ?? .black,
        opacity: 0.15,
        offset: CGSize(width: 0, height: 0.5),
        radius: 2
    )
}
