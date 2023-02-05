//
//  OpenMainWidgetViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol OpenMainWidgetViewControllerInterface: AnyObject {

}

class OpenMainWidgetViewController: UIViewController {
    var presenter: OpenMainWidgetPresenterInterface?
    
    private lazy var collectionView: UICollectionView = getCollectionViewCell()
    private var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        products = Array(DSF.shared.getAllStoredProducts()[0...3])
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
        4
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell: MealTimeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        
        cell.viewModel = .init(
            foods: products?.foods ?? [],
            mealtime: .breakfast
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
