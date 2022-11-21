//
//  SelectView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 21.11.2022.
//

import UIKit

final class SelectView<ID: WithGetTitleProtocol>: UIView {
    var selectedCellType: ID? { getSelectedCell()?.id }
    var didTapButton: ((ID) -> Void)?
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private var isCollapsed = false
    
    private let models: [ID]
    
    init(_ models: [ID]) {
        self.models = models
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        configureStack()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 22
        
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
        }
    }
    
    private func configureStack() {
        models.forEach {
            let cell = SelectViewCell($0)
            cell.addTarget(self, action: #selector(didTapCell), for: .touchUpInside)
            stackView.addArrangedSubview(cell)
        }
    }
    
    private func close(_ index: Int) {
        isCollapsed = true
        if index == -1 {
            return
        } else if let selectedIndex = getSelectedCellIndex(), index == selectedIndex {
            self.close(index - 1)
        } else {
            UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[safe: index]?.layer.opacity = 0
                self.stackView.arrangedSubviews[safe: index]?.isHidden = true
            } completion: { _ in
                self.close(index - 1)
            }
        }
    }
    
    private func show(_ index: Int) {
        isCollapsed = false
        if index == models.count {
            return
        } else if let selectedIndex = getSelectedCellIndex(), index == selectedIndex {
            self.show(index + 1)
        } else {
            UIView.animate(withDuration: 0.08, delay: 0, options: .curveEaseInOut) {
                self.stackView.arrangedSubviews[safe: index]?.layer.opacity = 1
                self.stackView.arrangedSubviews[safe: index]?.isHidden = false
            } completion: { _ in
                self.show(index + 1)
            }
        }
    }
    
    private func getSelectedCell() -> SelectViewCell<ID>? {
        stackView.arrangedSubviews
            .first(where: { ($0 as? SelectViewCell<ID>)?.isSelectedCell ?? false })
        as? SelectViewCell<ID>
    }
    
    private func getSelectedCellIndex() -> Int? {
        stackView.arrangedSubviews
            .enumerated()
            .first(where: { ($0.element as? SelectViewCell<ID>)?.isSelectedCell ?? false })?
            .offset
    }
    
    @objc private func didTapCell(_ sender: UIControl) {
        guard !isCollapsed else {
            show(0)
            return
        }
        guard let selectedCell = sender as? SelectViewCell<ID> else { return }
        stackView.arrangedSubviews.forEach {
            if let anyCell = $0 as? SelectViewCell<ID> {
                anyCell.isSelectedCell = anyCell.id.getTitle(.long) == selectedCell.id.getTitle(.long)
            }
        }
        
        didTapButton?(selectedCell.id)
        close(models.count)
    }
}
