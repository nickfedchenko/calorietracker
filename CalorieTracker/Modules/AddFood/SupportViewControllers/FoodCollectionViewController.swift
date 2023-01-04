//
//  FoodCollectionViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 10.11.2022.
//

import UIKit

protocol FoodCollectionViewControllerDataSource: AnyObject {
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell
    func foodsCount() -> Int
}

protocol FoodCollectionViewControllerDelegate: AnyObject {
    func didSelectCell(_ type: Food)
}

final class FoodCollectionViewController: UIViewController {
    enum CollectionViewLayout {
        case contentFitting
        case `default`
    }
    
    weak var dataSource: FoodCollectionViewControllerDataSource?
    weak var delegate: FoodCollectionViewControllerDelegate?
    
    var isSelectedType: AddFood = .recent
    
    var isScrollEnabled: Bool {
        get { collectionView.isScrollEnabled }
        set { collectionView.isScrollEnabled = newValue }
    }
    
    private(set) lazy var collectionView: UICollectionView = {
        let view: UICollectionView = {
            switch collectionViewLayput {
            case .contentFitting:
                return ContentFittingCollectionView(
                    frame: .zero,
                    collectionViewLayout: collectionViewFlowLayout
                )
            case .default:
                return UICollectionView(
                    frame: .zero,
                    collectionViewLayout: collectionViewFlowLayout
                )
            }
        }()
        
        view.clipsToBounds = true
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
    
    private let collectionViewLayput: CollectionViewLayout
    
    init(_ layout: CollectionViewLayout = .default) {
        self.collectionViewLayput = layout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        case .frequent, .recent, .favorites, .search:
            return 0
        case .myMeals, .myRecipes, .myFood:
            return 8
        }
    }
}

// MARK: - CollectionView DataSource

extension FoodCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource?.foodsCount() ?? 0
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
