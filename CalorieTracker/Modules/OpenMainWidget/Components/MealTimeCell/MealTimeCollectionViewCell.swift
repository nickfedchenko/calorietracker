//
//  MealTimeCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 05.02.2023.
//

import UIKit

class MealTimeCollectionViewCell: UICollectionViewCell {
    enum SizeState {
        case open
        case close
    }
    
    private lazy var header: MealTimeHeaderView = .init(frame: .zero)
    private lazy var shadowView: ViewWithShadow = .init(Const.shadows)
    private lazy var collectionView: UICollectionView = getCollectionView()
    
    private var headerBottomEqualToSuperviewConstraints: NSLayoutConstraint?
    private var headerBottomEqualToViewConstraints: NSLayoutConstraint?
    private var collectionViewHeightConstraints: NSLayoutConstraint?
    
    var viewModel: MealTimeCellViewModel? {
        didSet {
            didChangeViewModel()
        }
    }
    
    var sizeState: SizeState = .close {
        didSet {
            didChangeSizeState()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        didChangeSizeState()
        registerCells()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        return layoutAttributes
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        shadowView.layer.cornerCurve = .continuous
        shadowView.layer.cornerRadius = 12
        
        collectionView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        contentView.addSubviews(shadowView)
        contentView.addSubviews(header, collectionView)
        
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        header.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(11)
        }
        
        headerBottomEqualToSuperviewConstraints = header.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor
        )
        headerBottomEqualToViewConstraints = header.bottomAnchor.constraint(
            equalTo: collectionView.topAnchor,
            constant: -5
        )
        collectionViewHeightConstraints = collectionView.heightAnchor.constraint(
            equalToConstant: 0
        )
    }
    
    private func registerCells() {
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(FoodCollectionViewCell.self)
    }
    
    private func didChangeSizeState() {
        switch self.sizeState {
        case .open:
            guard let viewModel = self.viewModel, !viewModel.foods.isEmpty else { return }
            self.headerBottomEqualToSuperviewConstraints?.isActive = false
            self.headerBottomEqualToViewConstraints?.isActive = true
            self.collectionViewHeightConstraints?.isActive = false
            self.collectionView.isHidden = false
        case .close:
            self.headerBottomEqualToSuperviewConstraints?.isActive = true
            self.headerBottomEqualToViewConstraints?.isActive = false
            self.collectionViewHeightConstraints?.isActive = true
            self.collectionView.isHidden = true
        }
    }
    
    private func didChangeViewModel() {
        guard let viewModel = viewModel else { return }

        header.viewModel = .init(
            mealTime: viewModel.mealtime,
            burnKcal: viewModel.kcal,
            carbs: viewModel.carbs,
            protein: viewModel.protein,
            fat: viewModel.fats
        )
        
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Flow Layout

extension MealTimeCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.frame.width
        let height = width * 0.16
        return CGSize(
            width: width,
            height: height
        )
    }
}

// MARK: - CollectionView Delegate

extension MealTimeCollectionViewCell: UICollectionViewDelegate {
    
}

// MARK: - CollectionView DataSource

extension MealTimeCollectionViewCell: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel?.foods.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let viewModel = viewModel else {
            let defaultCell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return defaultCell
        }
        
        let cell: FoodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.viewModel = .init(
            cellType: .table,
            food: viewModel.foods[safe: indexPath.row],
            buttonType: .delete,
            subInfo: nil,
            colorSubInfo: nil
        )
        return cell
    }
}

// MARK: - Factory

extension MealTimeCollectionViewCell {
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = ContentFittingCollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        return collectionView
    }
}

// MARK: - Const

extension MealTimeCollectionViewCell {
    private struct Const {
        static let shadows: [Shadow] = [
            .init(
                color: .black,
                opacity: 0.03,
                offset: .init(width: 0, height: 1),
                radius: 16
            ),
            .init(
                color: .black,
                opacity: 0.03,
                offset: .init(width: 0, height: 1),
                radius: 8
            )
        ]
    }
}