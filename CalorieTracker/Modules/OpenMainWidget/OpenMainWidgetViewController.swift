//
//  OpenMainWidgetViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol OpenMainWidgetViewControllerInterface: AnyObject {
    func setDailyMeals(_ dailyMeals: [DailyMeal])
}

class OpenMainWidgetViewController: UIViewController {
    typealias Size = CTWidgetNodeConfiguration
    var isFirstAppear = true
    var presenter: OpenMainWidgetPresenterInterface?
    
    private lazy var collectionView: UICollectionView = getCollectionViewCell()
    private lazy var closeButton: UIButton = getCloseButton()

    private var sideInset: CGFloat { CTWidgetNode(with: .init(type: .widget)).constants.suggestedSideInset }
    
    private let mainWidgetTopInsets: [OpenMainWidgetPresentController.State: CGFloat] = [
        .full: 42,
        .modal: 19
    ]

    private var dailyMeals: [DailyMeal]? {
        didSet {
            didChnageDailyMeals()
        }
    }
    
    private var viewModels: [MealTimeCellViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateDailyMeals()
        setupView()
        setupConstraints()
        registerCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard isFirstAppear else { return }
        changeStateVC(.modal)
        isFirstAppear.toggle()
    }
    
    private func setupView() {
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = R.color.openMainWidget.background()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(
            top: mainWidgetTopInsets[.modal] ?? 0,
            left: 0,
            bottom: 0,
            right: 0
        )
        
    }
    
    private func setupConstraints() {
        view.addSubviews(collectionView, closeButton)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func registerCells() {
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(MealTimeCollectionViewCell.self)
        collectionView.register(MainWidgetCollectionViewCell.self)
    }
    
    private func changeStateVC(_ state: OpenMainWidgetPresentController.State) {
        (navigationController?.presentationController as? OpenMainWidgetPresentController)?.state = state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.collectionView.contentInset = .init(
                top: self.mainWidgetTopInsets[state] ?? 0,
                left: 0,
                bottom: 0,
                right: 0
            )
        }
    }
    
    private func deleteFood(food: Food, mealTime: MealTime) -> Bool {
        guard let mealDataId = dailyMeals?
            .first(where: { $0.mealTime == mealTime })?.mealData
            .first(where: { $0.food == food })?.id
        else { return false }
        
        if case let .customEntry(customEntry) = food {
            FDS.shared.deleteCustomEntry(customEntry.id)
        }
        
        return FDS.shared.deleteMealData(mealDataId)
    }
    
    private func didChnageDailyMeals() {
        guard let dailyMeals = dailyMeals else { return }

        viewModels = dailyMeals.map { dailyMeal in
            var newViewModel = MealTimeCellViewModel(
                foods: dailyMeal.mealData.compactMap { $0.food },
                mealtime: dailyMeal.mealTime
            )
            
            if newViewModel.foods.isEmpty {
                newViewModel.sizeState = .close
            }
            
            return newViewModel
        }

        collectionView.reloadData()
    }
    
    @objc private func didTapCloseButton() {
        changeStateVC(.modal)
        presenter?.didTapCloseButton()
    }
}

extension OpenMainWidgetViewController: OpenMainWidgetViewControllerInterface {
    func setDailyMeals(_ dailyMeals: [DailyMeal]) {
        self.dailyMeals = dailyMeals
        guard let model = presenter?.getMainWidgetWidget() else { return }
        (self.collectionView.cellForItem(at: IndexPath(row: 0, section: 0)) as? MainWidgetCollectionViewCell)?
            .configure(model)
    }
}

// MARK: - CollectionView Delegate

extension OpenMainWidgetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width - 2 * sideInset
        let height: CGFloat = 80
        return CGSize(width: width, height: height)
    }
}

// MARK: - CollectionView Delegate

extension OpenMainWidgetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MealTimeCollectionViewCell else {
            if let cell = collectionView.cellForItem(at: indexPath) as? MainWidgetCollectionViewCell {
                didTapCloseButton()
            }
            return
        }
        
        if let viewModel = viewModels[safe: indexPath.row - 1], !viewModel.foods.isEmpty {
            viewModels[indexPath.row - 1].sizeState = viewModel.sizeState == .close
                ? .open
                : .close
            if viewModels[indexPath.row - 1].sizeState == .open {
                changeStateVC(.full)
            }
            
            cell.invalidateIntrinsicContentSize()
            collectionView.reloadItems(at: [indexPath])
        }
    }
}

// MARK: - CollectionView DataSource

extension OpenMainWidgetViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModels.count + 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let model = presenter?.getMainWidgetWidget() else {
                return collectionView.dequeueReusableCell(for: indexPath)
            }
            let cell: MainWidgetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(model)
            return cell
        default:
            let cell: MealTimeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            
            cell.viewModel = viewModels[safe: indexPath.row - 1]
            cell.addButtonhandler = { mealTime in
                self.changeStateVC(.full)
                self.presenter?.didTapAddButton(mealTime)
            }
            cell.deleteFoodHandler = { [weak self] food, mealTime in
                if self?.deleteFood(food: food, mealTime: mealTime) == true {
                    self?.presenter?.updateDailyMeals()
                    collectionView.reloadItems(at: [indexPath])
                }
            }
            cell.tapedCellHandler = { [weak self] food in
                self?.presenter?.didTapFoodCell(food)
            }
            
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
}

// MARK: - Factory

extension OpenMainWidgetViewController {
    private func getCollectionViewCell() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
        return button
    }
}
