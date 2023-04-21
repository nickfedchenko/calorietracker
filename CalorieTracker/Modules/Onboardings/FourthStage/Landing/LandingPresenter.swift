//
//  LandingPresenter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.04.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import UIKit

protocol LandingPresenterInterface: AnyObject {
    func getNumberOfSections() -> Int
    func getNumberOfItemsInSection(section: Int) -> Int
    func makeCell(for indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionViewCell?
    func makeHeader(for indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionReusableView?
}

class LandingPresenter {
    
    unowned var view: LandingViewControllerInterface
    let router: LandingRouterInterface?
    let interactor: LandingInteractorInterface?
    private let sections: [LandingSectionType]
    init(
        interactor: LandingInteractorInterface,
        router: LandingRouterInterface,
        view: LandingViewControllerInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.sections = interactor.makeSectionsModel()
    }
}

extension LandingPresenter: LandingPresenterInterface {
    func getNumberOfSections() -> Int {
        sections.count
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        let section = sections[section]
        switch section {
        case .reviewsSection(model: let model):
            return model.reviewsImages.count
        default:
            return 1
        }
    }
    
    func makeCell(for indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionViewCell? {
        let section = sections[indexPath.section]
        switch section {
        case .topSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingTopCell.identifier,
                for: indexPath
            ) as? LandingTopCell
            cell?.configure(with: model)
            return cell
        case .chartSection(chartSnapshot: let snapshot):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingChartCell.identifier,
                for: indexPath
            ) as? LandingChartCell
            cell?.configure(with: snapshot)
            return cell
        case .checkmarksSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingCheckmarksCell.identifier,
                for: indexPath
            ) as? LandingCheckmarksCell
            cell?.configure(with: model)
            return cell
        case .circlesSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingCirclesCell.identifier,
                for: indexPath
            ) as? LandingCirclesCell
            cell?.configure(with: model)
            return cell
        case .benefitsSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingBenefitsCell.identifier,
                for: indexPath
            ) as? LandingBenefitsCell
            cell?.configure(with: model)
            return cell
        case .activityIntegration(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingActivityCell.identifier,
                for: indexPath
            ) as? LandingActivityCell
            cell?.configure(with: model)
            return cell
        case .recipesSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingRecipesCell.identifier,
                for: indexPath
            ) as? LandingRecipesCell
            cell?.configure(with: model)
            return cell
        case .measurementsSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingMeasurementsCell.identifier,
                for: indexPath
            ) as? LandingMeasurementsCell
            cell?.configure(with: model)
            return cell
        case .waterSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingWaterCell.identifier,
                for: indexPath
            ) as? LandingWaterCell
            cell?.configure(with: model)
            return cell
        case .reviewsSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingReviewCell.identifier,
                for: indexPath
            ) as? LandingReviewCell
            cell?.configure(with: model.reviewsImages[indexPath.item])
            return cell
        case .finalSection(model: let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LandingFinalCell.identifier,
                for: indexPath
            ) as? LandingFinalCell
            cell?.configure(with: model)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func makeHeader(for indexPath: IndexPath, for collectionView: UICollectionView) -> UICollectionReusableView? {
        let section = sections[indexPath.section]
        switch section {
        case .recipesSection(model: let model):
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: LandingRecipesHeader.identifier, for: indexPath
            ) as? LandingRecipesHeader
            header?.configure(with: model)
            return header
        default:
            return nil
        }
    }
}
