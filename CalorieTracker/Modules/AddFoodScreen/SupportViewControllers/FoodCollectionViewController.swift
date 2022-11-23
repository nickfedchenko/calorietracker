//
//  FoodCollectionViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 10.11.2022.
//

import UIKit

protocol FoodCollectionViewControllerDataSource: AnyObject {
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func productsCount() -> Int
    func dishesCount() -> Int
    func mealsCount() -> Int
}

protocol FoodCollectionViewControllerDelegate: AnyObject {
    func didSelectCell(_ type: Food)
}

final class FoodCollectionViewController: UIViewController {
    weak var dataSource: FoodCollectionViewControllerDataSource?
    weak var delegate: FoodCollectionViewControllerDelegate?
    
    var isSelectedType: AddFood = .recent
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowLayout
        )
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        view.contentInset = .init(top: 0, left: 0, bottom: 20, right: 0)
        return view
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCells()
        addSubviews()
        setupConstraints()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func registerCells() {
        collectionView.register(RecipesColectionViewCell.self)
        collectionView.register(FoodCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func addSubviews() {
        view.addSubviews(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView Delegate

extension FoodCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FoodCellProtocol,
               let type = cell.foodType else { return }
        delegate?.didSelectCell(type)
    }
}

extension FoodCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width - 40
        let height: CGFloat = 64
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            return 0
        case .myMeals, .myRecipes, .myFood:
            return 8
        }
    }
}

// MARK: - CollectionView DataSource

extension FoodCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            return 2
        case .myMeals:
            return 1
        case .myRecipes:
            return 0
        case .myFood:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch isSelectedType {
        case .frequent, .recent, .favorites:
            return section == 0
                ? dataSource?.productsCount() ?? 0
                : dataSource?.dishesCount() ?? 0
        case .myMeals:
            return dataSource?.mealsCount() ?? 0
        case .myRecipes:
            return 0
        case .myFood:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dataSource?.cell(
            collectionView: collectionView,
            indexPath: indexPath
        ) else {
            let defaultCell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return defaultCell
        }
        
        return cell
    }
}
