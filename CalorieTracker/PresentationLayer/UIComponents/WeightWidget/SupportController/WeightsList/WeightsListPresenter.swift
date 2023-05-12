//
//  WeightsListPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit
typealias WeightsListDataSource = UITableViewDiffableDataSource<Int, WeightsListCellType>

protocol WeightsListPresenterInterface: AnyObject {
    func viewDidLoad(with tableView: UITableView)
    func changeMode(to mode: WeightsListPresenter.SelectedMode)
    func didTapToDelete(model: WeightsListCellType)
    func didTapToEnterWeight()
    func updateTableView()
    var shouldShowDataFromHK: Bool { get set }
}

class WeightsListPresenter {
    enum SelectedMode {
        case daily, weekly, monthly
    }
    
    private var selectedMode: SelectedMode = .daily {
        didSet {
            updateDateSource(for: selectedMode)
        }
    }
    
    unowned var view: WeightsListViewControllerInterface
    let router: WeightsListRouterInterface?
    let interactor: WeightsListInteractorInterface?
    private var dataSource: WeightsListDataSource?
    var shouldShowDataFromHK: Bool = UDM.weightsListShouldShowHKRecords {
        didSet {
            updateDateSource(for: selectedMode)
        }
    }
    
    init(
        interactor: WeightsListInteractorInterface,
        router: WeightsListRouterInterface,
        view: WeightsListViewControllerInterface
      ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func updateDateSource(for mode: SelectedMode) {
        guard let models = interactor?.makeModelsFor(mode: selectedMode, isFromHK: shouldShowDataFromHK) else {
            return
        }
        var snapshot: NSDiffableDataSourceSnapshot<Int, WeightsListCellType> = NSDiffableDataSourceSnapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(models, toSection: 0)
        dataSource?.apply(snapshot, animatingDifferences: true)
        view.updateInsets()
    }
}

extension WeightsListPresenter: WeightsListPresenterInterface {
    func didTapToDelete(model: WeightsListCellType) {
        interactor?.deleteModel(model: model)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            guard let self = self else { return }
            self.updateDateSource(for: self.selectedMode)
        }
    }
    
    func viewDidLoad(with tableView: UITableView) {
        let models = interactor?.makeModelsFor(mode: .daily, isFromHK: true)
        dataSource = .init(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier in
            guard let self = self else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: WeightsListCell.identifier,
                for: indexPath
            ) as? WeightsListCell else {
                return UITableViewCell()
            }
            cell.configure(model: itemIdentifier)
            cell.delegate = self.view
            return cell
        })
    }
    
    func changeMode(to mode: SelectedMode) {
        selectedMode = mode
    }
    
    func didTapToEnterWeight() {
        router?.openEnterWeightController()
    }
    
    func updateTableView() {
        updateDateSource(for: selectedMode)
    }
}
