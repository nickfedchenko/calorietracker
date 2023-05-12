//
//  WeightsListViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol WeightsListViewControllerInterface: AnyObject, WeightsListCellDelegate {
    func updateInsets()
}

class WeightsListViewController: UIViewController {
    var presenter: WeightsListPresenterInterface?
    private var blurRadiusDriver: UIViewPropertyAnimator?
    private let header = WeightsListHeader()
    private lazy var footer: WeightsListFooter =  {
       let footer = WeightsListFooter()
        footer.delegate = self
        return footer
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.register(WeightsListCell.self, forCellReuseIdentifier: WeightsListCell.identifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.allowsSelection = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset.left = -20
        tableView.showsVerticalScrollIndicator = false
        tableView.bounces = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSubviews()
        presenter?.viewDidLoad(with: tableView)
        presenter?.changeMode(to: .daily)
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        tableView.contentInset = UIEdgeInsets(
            top: header.frame.height,
            left: 0,
            bottom: footer.frame.height,
            right: 0
        )
        
        print(tableView.contentInset)
    }
    
    func updateInsets() {
        tableView.contentInset = UIEdgeInsets(
            top: header.frame.height,
            left: 0,
            bottom: footer.frame.height,
            right: 0
        )
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubviews(tableView, header, footer)
        header.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(188)
        }
        
        footer.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
            
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        header.segmentChanged = { [weak self] type in
            switch type {
            case .listDaily:
                self?.presenter?.changeMode(to: .daily)
            case .listWeekly:
                self?.presenter?.changeMode(to: .weekly)
            case .listMonthly:
                self?.presenter?.changeMode(to: .monthly)
            default:
                return
            }
        }
        
        header.HKselectorChanged = { [weak self] isOn in
            self?.presenter?.shouldShowDataFromHK = isOn
            UDM.weightsListShouldShowHKRecords = isOn
        }
    }
}

extension WeightsListViewController: WeightsListViewControllerInterface {
    func didTapToDelete(record: WeightsListCellType) {
        presenter?.didTapToDelete(model: record)
    }
}

extension WeightsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        56
    }
    
//    func tableView(
//        _ tableView: UITableView,
//        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
//    ) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
//                    // delete the item here
//                    completionHandler(true)
//                }
//        deleteAction.image = R.image.weightWidget.trashBinIcon()
//                deleteAction.backgroundColor = .white
//                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//                return configuration
//    }
}

extension WeightsListViewController: WeightsListFooterDelegate {
    func didTapToCloseButton() {
        Vibration.success.vibrate()
        dismiss(animated: true)
    }
    
    func didTapToAddWeightButton() {
        presenter?.didTapToEnterWeight()
    }
}
