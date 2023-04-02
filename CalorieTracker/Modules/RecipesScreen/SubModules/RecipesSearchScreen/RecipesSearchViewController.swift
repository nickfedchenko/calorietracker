//
//  RecipesSearchViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol RecipesSearchViewControllerInterface: AnyObject {
    func searchFinished()
}

class RecipesSearchViewController: UIViewController {
    var presenter: RecipesSearchPresenterInterface?
    private let footer = RecipesSearchFooter()
    
    private lazy var searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] section, _ in
            if section == 1 {
                return self!.makeListLayoutSection()
            } else {
                return self!.makeTopSectionLayoutSection()
            }
        })
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipeListCell.self, forCellWithReuseIdentifier: RecipeListCell.identifier)
        collectionView.register(SelectedTagsCell.self, forCellWithReuseIdentifier: SelectedTagsCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 166,
            right: 0
        )
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSubviews()
        setupKeyboardObservers()
        setupDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateFiltersButtonAppearance()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDelegates() {
        footer.delegate = self
    }
    
    private func updateFiltersButtonAppearance() {
        guard let tags = presenter?.getSelectedTags() else { return }
        !tags.isEmpty ? footer.showFiltersBadge() : footer.hideFiltersBadge()
    }
    
    private func makeTopSectionLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(view.bounds.width - 20),
            heightDimension: .absolute(presenter?.calculateTopCellHeight() ?? 0)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(8)
        group.contentInsets.leading = 20
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func makeListLayoutSection() -> NSCollectionLayoutSection {
        let itemCount = CGFloat(presenter?.getNumberOfItems(in: 1) ?? 1)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(64)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(view.bounds.width - 20),
            heightDimension: .absolute(itemCount * 64 + (8 * (itemCount - 1)) + 20)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: Int(itemCount == 0 ? 1 : itemCount)
        )
        group.contentInsets.leading = 20
        group.contentInsets.top = 20
        
        group.interItemSpacing = .fixed(8)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func setupAppearance() {
        shouldHideTabBar = true
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubviews(searchResultCollectionView)
        view.addSubview(footer)
        footer.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(215)
        }
        
        searchResultCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupHandlers() {
        footer.backButtonTappedHandler = popBack
        footer.filtersButtonTapHandler = { [weak self] in
            self?.presenter?.filterButtonTapped()
        }
    }
    
    private func shouldShowFiltersSelector() {
        presenter?.filterButtonTapped()
    }
    
    private func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillShow(_:)),
                    name: UIResponder.keyboardWillShowNotification,
                    object: nil
                )

                // Subscribe to Keyboard Will Hide notifications
                NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(keyboardWillHide(_:)),
                    name: UIResponder.keyboardWillHideNotification,
                    object: nil
                )
    }
    
    @objc func keyboardWillShow(
        _ notification: NSNotification
    ) {
        let frameKey = UIResponder.keyboardFrameEndUserInfoKey
        guard
            let value = notification.userInfo?[frameKey] as? NSValue else {
            return
        }
        let height = value.cgRectValue.height
        
        footer.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(120 + height)
        }
        
        footer.state = .expanded
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(
        _ notification: NSNotification
    ) {
        footer.snp.remakeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(215)
        }
        footer.state = .compact
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension RecipesSearchViewController: RecipesSearchViewControllerInterface {
    func searchFinished() {
        DispatchQueue.main.async { [weak self] in
            self?.searchResultCollectionView.reloadSections(IndexSet(integersIn: 0...1))
        }
    }
}
//
extension RecipesSearchViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section == 0 {
           guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedTagsCell.identifier,
                for: indexPath
            ) as? SelectedTagsCell else {
                return UICollectionViewCell()
            }
            if let selectedTags = presenter?.getSelectedTags() {
                cell.configure(selectedTags: selectedTags)
                cell.delegate = self
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                 withReuseIdentifier: RecipeListCell.identifier,
                 for: indexPath
             ) as? RecipeListCell,
                  let model = presenter?.getDishModel(at: indexPath)
            else {
                 return UICollectionViewCell()
             }
            if let targetModel = LightweightRecipeModel(from: model) {
                cell.configure(with: targetModel)
            }
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter?.getNumberOfItems(in: section) ?? 0
    }
}

extension RecipesSearchViewController: SelectedTagsCellDelegate {
    func shouldDeleteFilter(tag: SelectedTagsCell.TagType) {
        presenter?.removeTagFormSelected(tag: tag)
        updateFiltersButtonAppearance()
    }
}

extension RecipesSearchViewController: RecipesSearchFooterDelegate {
    func searchPhraseChanged(to phrase: String) {
        presenter?.performSearch(with: phrase)
    }
}

extension RecipesSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectRecipe(at: indexPath)
    }
}
