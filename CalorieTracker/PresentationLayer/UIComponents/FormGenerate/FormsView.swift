//
//  FormsView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class FormsView: UIView {
    private lazy var collectionView: ContentFittingCollectionView = {
        let collectionView = ContentFittingCollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewLayout
        )
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var collectionViewLayout: CollectionViewRightAlignedLayout = {
        let layout = CollectionViewRightAlignedLayout()
        return layout
    }()
    
    let formModels: [FormModel]
    
    init(_ models: [FormModel]) {
        self.formModels = models
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        registerCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerCell() {
        collectionView.register(FormCollectionViewCell.self)
        collectionView.register(NutritionFactsCollectionViewCell.self)
    }
    
    private func setupView() {
        clipsToBounds = false
        layer.masksToBounds = false
    }
    
    private func setupConstraints() {
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension FormsView: UICollectionViewDelegate {
    
}

extension FormsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: (formModels[safe: indexPath.row]?.width.rawValue ?? 1.0) * bounds.width,
            height: 48
        )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

extension FormsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return formModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FormCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.model = formModels[safe: indexPath.row]
        return cell
    }
}
