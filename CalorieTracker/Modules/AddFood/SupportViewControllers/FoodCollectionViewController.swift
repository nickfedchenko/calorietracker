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
    func foodsOverAll() -> [Food]
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
    
    var createHandler: (() -> Void)?
    var someFoodAdded: ((Food) -> Void)?
    
    var isSelectedType: AddFood = .recent
    
    lazy var mealCellsHeight: [CGFloat] = Array(
        repeating: 104,
        count: collectionView.numberOfItems(inSection: 0)
    )
        
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
        view.keyboardDismissMode = .onDrag
        return view
    }()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()
    
    private lazy var nothingWasFoundView = NothingWasFoundView()
    
    private let collectionViewLayput: CollectionViewLayout
    
    var shouldShowNothingFound: Bool = false
    
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
        if (dataSource?.foodsCount() ?? 0) > 0 {
            collectionView.performBatchUpdates {
                self.collectionView.reloadSections(IndexSet(integer: 0))
            }
        } else {
            collectionView.reloadData()
        }
        guard shouldShowNothingFound else { return }
        nothingWasFoundView.isHidden = (dataSource?.foodsCount() ?? 0) != 0
    }
    
    private func registerCells() {
        collectionView.register(MealsCollectionViewCell.self)
        collectionView.register(RecipesColectionViewCell.self)
        collectionView.register(FoodCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        nothingWasFoundView.isHidden = true
        nothingWasFoundView.createHandler = {
            self.createHandler?()
        }
    }
    
    private func addSubviews() {
        view.addSubviews(
            collectionView,
            nothingWasFoundView
        )
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        nothingWasFoundView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).multipliedBy(0.7)
            make.centerX.equalToSuperview()
        }
    }
}

// MARK: - CollectionView Delegate

extension FoodCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MealsCollectionViewCell {
            let mainCellHeight = cell.frame.height - cell.tableView.frame.height
            let cellHeight = cell.tableView.contentSize.height + mainCellHeight
            mealCellsHeight[indexPath.item] = mealCellsHeight[indexPath.item] == 104 ? cellHeight : 104
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.3)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
            collectionView.performBatchUpdates {
                cell.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
            CATransaction.commit()
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? FoodCellProtocol,
              let type = cell.foodType else { return }
        delegate?.didSelectCell(type)
    }
}

extension FoodCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height: CGFloat = isSelectedType == .myMeals ?
        mealCellsHeight[indexPath.row] : 62
        let width = view.frame.width - 40
        let size = CGSize(width: width, height: height)
        return size
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch isSelectedType {
        case .frequent, .recent, .favorites, .search:
            return 1
        case .myRecipes, .myFood:
            return 8
        case .myMeals:
            return 16
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        
        return UIEdgeInsets(
            top: isSelectedType == .myMeals ? 5 : 0,
            left: 0,
            bottom: 20,
            right: 0
        )
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
