//
//  LandingViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol LandingViewControllerInterface: AnyObject {

}

class LandingViewController: UIViewController {
    var presenter: LandingPresenterInterface?
    private var didScrollToReview: Bool = false
    private lazy var collectionView: UICollectionView = {
       let layout = makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LandingTopCell.self, forCellWithReuseIdentifier: LandingTopCell.identifier)
        collectionView.register(LandingChartCell.self)
        collectionView.register(LandingCheckmarksCell.self)
        collectionView.register(LandingCirclesCell.self)
        collectionView.register(LandingBenefitsCell.self)
        collectionView.register(LandingActivityCell.self)
        collectionView.register(LandingRecipesCell.self)
        collectionView.register(LandingMeasurementsCell.self)
        collectionView.register(LandingWaterCell.self)
        collectionView.register(LandingReviewCell.self)
        collectionView.register(LandingFinalCell.self)
        collectionView.register(
            LandingRecipesHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: LandingRecipesHeader.identifier
        )
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        return collectionView
    }()
    
    private let continueButton: CommonButton = .init(
        style: .gradientBorderedWithBlur,
        text: R.string.localizable.onboardingFirstCallToAchieveGoalButton().uppercased()
    )
    
    private let buttonBlur: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupSubviews() {
        view.backgroundColor = UIColor(hex: "E9E9ED")
        view.addSubviews(collectionView, continueButton)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview().inset(47)
            make.bottom.equalToSuperview().inset(80.fitH)
        }
        
//        buttonBlur.layer.cornerRadius = continueButton.layer.cornerRadius
//        buttonBlur.clipsToBounds = true
//        buttonBlur.contentView.addSubview(continueButton)
//        buttonBlur.alpha = 0.9
//        continueButton.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layoutConfig = UICollectionViewCompositionalLayoutConfiguration()
        layoutConfig.interSectionSpacing = 0
        layoutConfig.scrollDirection = .vertical
        let layout = UICollectionViewCompositionalLayout { [weak self] index, environment in
            return self?.makeSection(for: index, environment: environment)
        }
        layout.configuration = layoutConfig
        return layout
    }
    
    private func makeSection(for index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let itemsInSection = CGFloat(presenter?.getNumberOfItemsInSection(section: index) ?? 0)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: getWidthDimensionForItem(at: index, environment: environment),
            heightDimension: getHeightDimensionForItem(at: index, environment: environment)
        )
        
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: getWidthDimensionForGroup(at: index, environment: environment),
            heightDimension: getHeightDimensionForGroup(at: index, environment: environment)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Int(itemsInSection == 0 ? 1 : itemsInSection)
        )
        
//        group.interItemSpacing = .fixed(8)
//        let headerSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1),
//            heightDimension: .estimated(24)
//        )
        
        let header = makeHeader(for: index)
        let section = NSCollectionLayoutSection(group: group)
        if index == 6 || index == 9 {
            section.orthogonalScrollingBehavior = .continuous
        }
        section.boundarySupplementaryItems = header != nil ? [header!] : []
        section.supplementariesFollowContentInsets = true
        group.supplementaryItems = header != nil ? [header!] : []
        section.contentInsets = makeSectionInsetFor(section: index)
        return section
    }
    
    private func makeSectionInsetFor(section: Int) -> NSDirectionalEdgeInsets {
        switch section {
        case 1:
            return NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0)
        case 2:
            return NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0)
        case 4:
            return NSDirectionalEdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0)
        case 5:
            return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        case 6:
            return NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0)
        case 9:
            return NSDirectionalEdgeInsets(top: 10, leading: 37, bottom: 0, trailing: 37)
        case 10:
            return NSDirectionalEdgeInsets(top: 29, leading: 0, bottom: 0, trailing: 0)
        default:
            return .zero
        }
    }
    
    private func getWidthDimensionForItem(
        at section: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutDimension {
        switch section {
        case 9:
            return .fractionalWidth(0.2)
        default:
            return .fractionalWidth(1)
        }
    }
    
    private func getHeightDimensionForItem(
        at section: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutDimension {
        switch section {
        case 0:
            return .estimated(198.fitH)
        case 1:
            return .absolute(263)
        case 2:
            return .estimated(340)
        case 3:
            return .estimated(482)
        case 4:
            return .absolute(437)
        case 5:
            return .estimated(280)
        case 6:
            return .absolute(252)
        case 7:
            return .absolute(326)
        case 8:
            return .absolute(319)
        case 9:
            return .absolute(314)
        case 10:
            return .estimated(516)
        default:
            return .estimated(198.fitH)
        }
    }
    
    private func getWidthDimensionForGroup(
        at section: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutDimension {
        switch section {
        case 6:
            return .estimated(1122)
        case 9:
            return .absolute(1770)
        default:
            return .fractionalWidth(1)
        }
    }
    
    private func getHeightDimensionForGroup(
        at section: Int,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutDimension {
        switch section {
        case 0:
            return .estimated(198.fitH)
        case 1:
            return .estimated(279)
        case 2:
            return .estimated(340)
        case 3:
            return .estimated(482)
        case 4:
            return .estimated(437)
        case 5:
            return .estimated(280)
        case 6:
            return .estimated(252)
        case 7:
            return .estimated(326)
        case 8:
            return .absolute(319)
        case 9:
            return .estimated(314)
        case 10:
            return .estimated(516)
        default:
            return .estimated(198.fitH)
        }
    }
    
    private func makeHeader(for section: Int) -> NSCollectionLayoutBoundarySupplementaryItem? {
        switch section {
        case 6:
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: getWidthDimensionForHeader(at: section),
                    heightDimension: getHeightDimensionForHeader(at: section)
                    ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading,
                absoluteOffset: CGPoint(x: 0, y: 0)
            )
            return header
        default:
            return nil
        }
    }
    
    private func getWidthDimensionForHeader(at section: Int) -> NSCollectionLayoutDimension {
        switch section {
        default:
            return .fractionalWidth(1)
        }
    }
    
    private func getHeightDimensionForHeader(at section: Int) -> NSCollectionLayoutDimension {
        switch section {
        case 6:
            return .estimated(54)
        default:
            return .fractionalHeight(1)
        }
    }
}

extension LandingViewController: LandingViewControllerInterface {

}

extension LandingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.getNumberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        presenter?.makeCell(for: indexPath, for: collectionView) ?? UICollectionViewCell()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = presenter?.makeHeader(for: indexPath, for: collectionView)
            return header ?? UICollectionReusableView()
        } else {
            return UICollectionReusableView()
        }
    }
}

extension LandingViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 9 && indexPath.item == 0 && !didScrollToReview {
            UIView.animate(withDuration: 1.5) {
                self.collectionView.scrollToItem(
                    at: IndexPath(item: 1, section: 9),
                    at: .centeredHorizontally,
                    animated: false
                )
            } completion: { _ in
                self.didScrollToReview = true
            }
        }
        if indexPath.section == 7 {
            guard let cell = cell as? LandingMeasurementsCell else {
                return
            }
            cell.showWeights()
        }
        
        if indexPath.section == 5 {
            guard let cell = cell as? LandingActivityCell else {
                return
            }
            cell.startAnimation()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if indexPath.section == 7 {
            guard let cell = cell as? LandingMeasurementsCell else { return }
            cell.hideWeights(shouldAnimate: true)
        }
    }
}
