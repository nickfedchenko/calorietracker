//
//  RecipesScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 03.08.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import NVActivityIndicatorView
import UIKit

protocol RecipesScreenViewControllerInterface: AnyObject {
    func shouldReloadDishesCollection(shouldRemoveActivity: Bool)
}

class RecipesScreenViewController: UIViewController {
    var isFirstLayout = true
    enum ScrollDirection {
        case up, down
    }
    var presenter: RecipesScreenPresenterInterface?
    
    let activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(
            frame: .zero,
            type: .ballRotate,
            color: UIColor(hex: "62D3B4"),
            padding: 60
        )
        return activityIndicator
    }()
    
//    private let selectorView = CTRecipesScreenSelector()
    
//    lazy var selectorHeightConstant: CGFloat = 48 {
//        didSet {
//            print("Selector height changed \(selectorHeightConstant)")
//        }
//    }
//    var isHeaderCurrentlyAnimation: Bool = false
    
//    let header = CTRecipesScreenHeader()
//    lazy var previousOffset: CGFloat = -152
//    lazy var currentOffset: CGFloat = 0
//    var selectorsAlpha: CGFloat {
//        selectorHeightConstant / 48
//    }
    
    private let blurView = UIVisualEffectView(effect: nil)
    private var blurRadiusDriver: UIViewPropertyAnimator?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "0C695E")
        label.font = R.font.sfProRoundedBold(size: 24)
        label.text = "Recipes".localized
        label.textAlignment = .left
        return label
    }()
    
    private let topPartContentView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.contentView.clipsToBounds = false
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = R.color.mainBackground()
        collectionView.bounces = false
        collectionView.contentInset = UIEdgeInsets(
            top: 108,
            left: 0,
            bottom: 120,
            right: 0
        )
        collectionView.register(RecipePreviewCell.self, forCellWithReuseIdentifier: RecipePreviewCell.identifier)
        collectionView.register(
            RecipesFolderHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: RecipesFolderHeader.identifier
        )
        collectionView.clipsToBounds = false
        collectionView.contentInsetAdjustmentBehavior = .never
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
        let itemsInSection = CGFloat(presenter?.numberOfItemsInSection(section: index) ?? 0)
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(160),
            heightDimension: .absolute(128)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(160 * itemsInSection + (8 * (itemsInSection - 1))),
            heightDimension: .absolute(128)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Int(itemsInSection == 0 ? 1 : itemsInSection)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter?.askForSections()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        presenter?.updateFavorites()
        shouldHideTabBar = false
        guard isFirstLayout else { return }
        showActivityIndicator()
        presenter?.askForSections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard
            !isFirstLayout else {
            isFirstLayout = false
            return
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        reinitBlurView()
    }
    
//    func updateTopViewHeight() {
//        isHeaderCurrentlyAnimation = true
//        selectorView.snp.remakeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.trailing.equalToSuperview()
//
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(selectorHeightConstant)
//        }
//
//        UIView.animate(withDuration: 0.1) {
//            self.selectorView.alpha = self.selectorsAlpha
//            self.view.layoutIfNeeded()
//        } completion: { _ in
//            self.isHeaderCurrentlyAnimation = false
//        }
//    }
    
    private func showActivityIndicator() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.activityIndicator.alpha = 1
        }
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.activityIndicator.alpha = 0
        }
    }
    
    private func setupSubviews() {
        view.addSubviews(collectionView)
        view.addSubview(blurView)
        blurView.contentView.addSubview(titleLabel)
             
        blurView.snp.makeConstraints { make in
            make.height.equalTo(84)
            make.top.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerX.centerY.equalToSuperview().inset(96)
            make.height.equalTo(UIScreen.main.bounds.width)
        }
    }
    
    private func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurView.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.1
    }
}

extension RecipesScreenViewController: RecipesScreenViewControllerInterface {
    func shouldReloadDishesCollection(shouldRemoveActivity: Bool) {
        if shouldRemoveActivity {
            hideActivityIndicator()
        }
        collectionView.reloadData()
    }
}

extension RecipesScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Got recipes count \(presenter?.numberOfItemsInSection(section: section) ?? 0)")
        return presenter?.numberOfItemsInSection(section: section) ?? 0
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
        ) as? RecipePreviewCell,
              let model = presenter?.getDishModel(at: indexPath) else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
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
           ) as? RecipesFolderHeader,
           let sectionModel = presenter?.getSectionModel(at: indexPath) {
            header.index = indexPath.section
            header.delegate = self
            header.configure(with: sectionModel)
            return header
        } else {
            return UICollectionReusableView()
        }
    }
}

extension RecipesScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapRecipe(at: indexPath)
    }
}

extension RecipesScreenViewController: RecipesFolderHeaderDelegate {
    func didSelectSectionHeader(at index: Int) {
        presenter?.didTapSectionHeader(at: index)
    }
}
