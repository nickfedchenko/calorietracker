//
//  ProgressSettingsViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 12.09.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol ProgressSettingsViewControllerInterface: AnyObject {

}

final class ProgressSettingsViewController: UIViewController {
    private lazy var saveButton: BasicButtonView = {
        let button = BasicButtonView(type: .save)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.progressScreen.close(), for: .normal)
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = R.string.localizable.progressSettingsTitle()
        label.font = R.font.sfProDisplaySemibold(size: 24)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private var isSelectedWidgetType: [WidgetType] = []
    private var isNotSelectedWidgetType: [WidgetType] = []
    
    var presenter: ProgressSettingsPresenterInterface?
    var didSaveData: (([WidgetType]) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupWidgetTypes()
    }
    
    private func setupWidgetTypes() {
        guard let widgetTypes = presenter?.getWidgetTypes() else { return }
        isSelectedWidgetType = widgetTypes
        isNotSelectedWidgetType = WidgetType.allCases.difference(from: isSelectedWidgetType)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        tableView.dragInteractionEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.register(WidgetTypeTableViewCell.self, forCellReuseIdentifier: "cell")
        if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
        
        view.addSubviews(
            titleLabel,
            tableView,
            saveButton,
            closeButton
        )
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.top.equalToSuperview().offset(64)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
            make.width.height.equalTo(64)
        }
        
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(closeButton.snp.top).offset(-20)
            make.height.equalTo(64)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-32)
        }
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSaveButton() {
        presenter?.saveWidgetTypes(isSelectedWidgetType)
        didSaveData?(isSelectedWidgetType)
        dismiss(animated: true)
    }
}

extension ProgressSettingsViewController: ProgressSettingsViewControllerInterface {

}

// MARK: - Table DataSource

extension ProgressSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? WidgetTypeTableViewCell
        
        switch indexPath.section {
        case 0:
            let type = isSelectedWidgetType[indexPath.row]
            cell?.isSelectedCell = true
            cell?.configure(type: type, color: type.getColor())
        case 1:
            let type = isNotSelectedWidgetType[indexPath.row]
            cell?.isSelectedCell = false
            cell?.configure(type: type, color: type.getColor())
        default:
            break
        }
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return isSelectedWidgetType.count
        case 1:
            return isNotSelectedWidgetType.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 24 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? SettingsHeaderView() : nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}

// MARK: - Table Delegate

extension ProgressSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? WidgetTypeTableViewCell else {
            return
        }
        
        cell.isSelectedCell = !cell.isSelectedCell
    
        switch cell.isSelectedCell {
        case true:
            isNotSelectedWidgetType.remove(at: indexPath.row)
            isSelectedWidgetType.insert(cell.type ?? .weight, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 0))
        case false:
            isSelectedWidgetType.remove(at: indexPath.row)
            isNotSelectedWidgetType.insert(cell.type ?? .weight, at: 0)
            tableView.moveRow(at: indexPath, to: IndexPath(row: 0, section: 1))
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath.section == destinationIndexPath.section else { return }
        isSelectedWidgetType.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
}

// MARK: - Table DnD

extension ProgressSettingsViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        
       return []
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) { }
    
    func tableView(_ tableView: UITableView,
                   dropSessionDidUpdate session: UIDropSession,
                   withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        switch destinationIndexPath?.section {
        case 0:
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        case 1:
            return UITableViewDropProposal(operation: .move, intent: .unspecified)
        default:
            return UITableViewDropProposal(operation: .move, intent: .unspecified)
        }
    }
}
