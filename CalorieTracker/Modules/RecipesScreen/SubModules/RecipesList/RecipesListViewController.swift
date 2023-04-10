//
//  RecipesListViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 25.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol RecipesListViewControllerInterface: AnyObject {
    
}

class RecipesListViewController: UIViewController {
    enum RecipesListMode {
        case columns, list
        mutating func toggle() {
            self = self == .list ? .columns : .list
        }
    }
    
    var presenter: RecipesListPresenterInterface?
    private var mode: RecipesListMode = .list
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.searchIcon(), for: .normal)
        return button
    }()
    
    private lazy var recipesListCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: makeListLayoutSection())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipePreviewCell.self, forCellWithReuseIdentifier: RecipePreviewCell.identifier)
        collectionView.register(RecipeListCell.self, forCellWithReuseIdentifier: RecipeListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(
            top: 96,
            left: 0,
            bottom: CTTabBarController.Constants.tabBarHeight,
            right: 0
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let header = CTRecipesScreenHeader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupSubviews()
        setupAppearance()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shouldHideTabBar = false
    }
    
    private func setupActions() {
        header.changeLayoutAction = { [weak self] in
            self?.mode.toggle()
            self?.updateLayout()
        }
        
        header.backButtonTapped = { [weak self] in
            self?.presenter?.backButtonTapped()
        }
        
        searchButton.addAction(
            UIAction { [weak self] _ in
                self?.presenter?.searchButtonTapped()
                LoggingService.postEvent(event: .recipesearch)
            },
            for: .touchUpInside
        )
    }
    
    private func updateLayout() {
        let layout = UICollectionViewCompositionalLayout(
            section: mode == .list ? makeListLayoutSection() : makeTwoColumnsSection()
        )
        recipesListCollectionView.setCollectionViewLayout(
            layout,
            animated: true
        )
        recipesListCollectionView.reloadSections(IndexSet(integer: 0))
    }
    
    private func makeListLayoutSection() -> NSCollectionLayoutSection {
        let itemCount = CGFloat(presenter?.getNumberOfItemsInSection() ?? 0)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(64)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(view.bounds.width - 20),
            heightDimension: .absolute(itemCount * 64 + (8 * (itemCount - 1)))
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: Int(itemCount)
        )
        group.contentInsets.leading = 20
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func makeTwoColumnsSection() -> NSCollectionLayoutSection {
        let itemCount = CGFloat(presenter?.getNumberOfItemsInSection() ?? 1)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute((view.bounds.width - 48) / 2),
            heightDimension: .absolute(143)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(view.bounds.width - 20),
            heightDimension: .absolute((itemCount / 2) * 143 + (8 * ((itemCount / 2) - 1)))
        )
        
        let subGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(143)
        )
        
        let subgroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: subGroupSize,
            subitem: item,
            count: 2
        )
        subgroup.interItemSpacing = .fixed(8)
        //        let twoItems
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: subgroup,
            count: Int(itemCount > 1 ? itemCount / 2 : 1)
        )
        group.contentInsets.leading = 20
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setupSubviews() {
        view.addSubview(recipesListCollectionView)
        view.addSubview(header)
        view.addSubview(searchButton)
        
        header.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(96)
        }
        
        recipesListCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.bottom.equalToSuperview().inset(108)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupAppearance() {
        header.setTitle(title: presenter?.getTitleForHeader() ?? "")
        view.backgroundColor = UIColor(hex: "F3FFFE")
    }
}

extension RecipesListViewController: RecipesListViewControllerInterface {
    
}

extension RecipesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectRecipe(at: indexPath)
    }
}

extension RecipesListViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let identifier = mode == .list ? RecipeListCell.identifier : RecipePreviewCell.identifier
        if mode == .list {
            guard
                let model = presenter?.getDishModel(at: indexPath),
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: identifier,
                    for: indexPath
                ) as? RecipeListCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        } else {
            guard
                let model = presenter?.getDishModel(at: indexPath),
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: identifier,
                    for: indexPath
                ) as? RecipePreviewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfItemsInSection() ?? 0
    }
}
