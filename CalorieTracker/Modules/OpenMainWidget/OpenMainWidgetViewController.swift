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
    var presenter: OpenMainWidgetPresenterInterface?
    
    private lazy var collectionView: UICollectionView = getCollectionViewCell()
    private var dailyMeals: [DailyMeal]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateDailyMeals()
        setupView()
        setupConstraints()
        registerCells()
    }
    
    private func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = R.color.mainBackground()
    }
    
    private func setupConstraints() {
        view.addSubviews(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func registerCells() {
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(MealTimeCollectionViewCell.self)
    }
}

extension OpenMainWidgetViewController: OpenMainWidgetViewControllerInterface {
    func setDailyMeals(_ dailyMeals: [DailyMeal]) {
        self.dailyMeals = dailyMeals
    }
}

// MARK: - CollectionView Delegate

extension OpenMainWidgetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width - 40
        let height: CGFloat = 64
        return CGSize(width: width, height: height)
    }
}

// MARK: - CollectionView Delegate

extension OpenMainWidgetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MealTimeCollectionViewCell else {
            return
        }
        
        cell.sizeState = cell.sizeState == .close
            ? .open
            : .close
        
        cell.invalidateIntrinsicContentSize()
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - CollectionView DataSource

extension OpenMainWidgetViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        dailyMeals?.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: MealTimeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let dailyMeal = dailyMeals?[safe: indexPath.row]
        cell.viewModel = .init(
            foods: dailyMeal?.mealData.compactMap { $0.food } ?? [],
            mealtime: dailyMeal?.mealTime ?? .breakfast
        )
        
        return cell
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
        return collectionView
    }
}
