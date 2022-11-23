//
//  NutritionFactsView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 16.11.2022.
//

import UIKit

final class NutritionFactsView: UIView {
    
    var viewModel: NutritionFactsVM! {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var collectionView: ContentFittingCollectionView = {
        let view = ContentFittingCollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private lazy var collectionViewLayout: CollectionViewRightAlignedLayout = {
        let layout = CollectionViewRightAlignedLayout()
        layout.minimumInteritemSpacing = 4
        return layout
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        layer.borderWidth = 2
        layer.borderColor = R.color.foodViewing.basicPrimary()?.cgColor
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        
        collectionView.register(NutritionFactsCollectionViewCell.self)
        collectionView.register(UICollectionViewCell.self)
    }
    
    private func setupConstraints() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
}

extension NutritionFactsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.viewModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = viewModel?.getCell(collectionView, indexPath: indexPath) else {
            let defaultCell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return defaultCell
        }
        return cell
    }
}

extension NutritionFactsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel?.getCellSize(collectionView.frame.width, indexPath: indexPath) ?? .zero
    }
}
