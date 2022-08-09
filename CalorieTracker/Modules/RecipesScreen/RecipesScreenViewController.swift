//
//  RecipesScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.08.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import AsyncDisplayKit
import UIKit

protocol RecipesScreenViewControllerInterface: AnyObject {
    
}

class RecipesScreenViewController: UIViewController {
    var presenter: RecipesScreenPresenterInterface?
    let layoutInspector = RecipesCollectionLayoutInspector()
    let header = RecipesFolderHeader()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.dataSource = self
        collectionView.backgroundColor = R.color.mainBackground()
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 84,
            right: 0
        )
        collectionView.register(RecipePreviewCell.self, forCellWithReuseIdentifier: RecipePreviewCell.identifier)
        collectionView.register(
            RecipesFolderHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecipesFolderHeader.identifier
        )
        return collectionView
    }()
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.interSectionSpacing = 16
        layoutConfig.scrollDirection = .vertical
        
        let layout = UICollectionViewCompositionalLayout { [weak self] index, _ in
            return self?.makeSection(for: index)
        }
        layout.configuration = layoutConfig
        return layout
    }
    
    private func makeSection(for index: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(128)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(160 * 8 + (8 * 7)),
            heightDimension: .absolute(128)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 8
        )
        group.interItemSpacing = .fixed(8)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(24)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading,
            absoluteOffset: CGPoint(x: 0, y: -8)
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [header]
        section.supplementariesFollowContentInsets = true
//                group.supplementaryItems = [header]
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
        return section
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension RecipesScreenViewController: RecipesScreenViewControllerInterface {
    
}

extension RecipesScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecipePreviewCell.identifier,
            for: indexPath
        ) as? RecipePreviewCell
        else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader,
           let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RecipesFolderHeader.identifier,
            for: indexPath
           ) as? RecipesFolderHeader {
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}
