//
//  RecipesSearchViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 26.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import UIKit

protocol RecipesSearchViewControllerInterface: AnyObject {
    func searchFinished(with dishes: [Dish])
}

class RecipesSearchViewController: UIViewController {
    var presenter: RecipesSearchPresenterInterface?
    private let footer = RecipesSearchFooter()
    
    private lazy var searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout(section: makeListLayoutSection())
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipeListCell.self, forCellWithReuseIdentifier: RecipeListCell.identifier)
//        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 216,
            right: 0
        )
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSubviews()
        setupKeyboardObservers()
        setupHandlers() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.addFilterTag(tag: .breakfast)
        presenter?.addFilterTag(tag: .garnish)
        presenter?.addExceptionTag(tag: .eggs)
        presenter?.performSearch(with: "")
        print("Phrase some phrase contains empty \("some phrase".contains(""))")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    private func setupAppearance() {
        shouldHideTabBar = true
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(footer)
        footer.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(215)
        }
    }
    
    private func setupHandlers() {
        footer.backButtonTappedHandler =  popBack
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
    func searchFinished(with dishes: [Dish]) {
        print(dishes)
    }
}
//
//extension RecipesSearchViewController: UICollectionViewDataSource {
//
//}
