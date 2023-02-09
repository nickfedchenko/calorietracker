//
//  OpenMainWidgetViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 02.02.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol OpenMainWidgetViewControllerInterface: AnyObject {
    func setDailyMeals(_ dailyMeals: [DailyMeal])
}

class OpenMainWidgetViewController: UIViewController {
    typealias Size = CTWidgetNodeConfiguration
    
    var presenter: OpenMainWidgetPresenterInterface?
    
    private lazy var collectionView: UICollectionView = getCollectionViewCell()
    private lazy var closeButton: UIButton = getCloseButton()

    private var sideInset: CGFloat { CTWidgetNode(with: .init(type: .widget)).constants.suggestedSideInset }
    private let mainWidgetTopInsets: [OpenMainWidgetPresentController.State: CGFloat] = [
        .full: 42,
        .modal: 19
    ]
    
    private var viewControllerTopInset: CGFloat {
        WidgetContainerViewController.safeAreaTopInset
        + WidgetContainerViewController.suggestedTopSafeAreaOffset
        + Size(type: .compact).height
        + WidgetContainerViewController.suggestedInterItemSpacing
    }
    
    private var dailyMeals: [DailyMeal]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.updateDailyMeals()
        setupView()
        setupConstraints()
        registerCells()
    }
    
    private func setupView() {
        view.backgroundColor = R.color.openMainWidget.background()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = .init(
            top: mainWidgetTopInsets[.modal] ?? 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
    
    private func setupConstraints() {
        view.addSubviews(collectionView, closeButton)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func registerCells() {
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(MealTimeCollectionViewCell.self)
        collectionView.register(MainWidgetCollectionViewCell.self)
    }
    
    private func changeStateVC() {
        (presentationController as? OpenMainWidgetPresentController)?.state = .full
        collectionView.contentInset = .init(
            top: mainWidgetTopInsets[.full] ?? 0,
            left: 0,
            bottom: 0,
            right: 0
        )
    }
    
    @objc private func didTapCloseButton() {
        presenter?.didTapCloseButton()
    }
}

extension OpenMainWidgetViewController: OpenMainWidgetViewControllerInterface {
    func setDailyMeals(_ dailyMeals: [DailyMeal]) {
        self.dailyMeals = dailyMeals
    }
}

// MARK: - CollectionView Delegate

extension OpenMainWidgetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = view.frame.width - 2 * sideInset
        let height: CGFloat = 64
        return CGSize(width: width, height: height)
    }
}

// MARK: - CollectionView Delegate

extension OpenMainWidgetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MealTimeCollectionViewCell else {
            return
        }
        
        cell.sizeState = cell.sizeState == .close
            ? .open
            : .close
        
        if cell.sizeState == .open {
            changeStateVC()
        }
        
        cell.invalidateIntrinsicContentSize()
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - CollectionView DataSource

extension OpenMainWidgetViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        (dailyMeals?.count ?? 0) + 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let model = presenter?.getMainWidgetWidget() else {
                return collectionView.dequeueReusableCell(for: indexPath)
            }
            let cell: MainWidgetCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(model)
            return cell
        default:
            let cell: MealTimeCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            let dailyMeal = dailyMeals?[safe: indexPath.row - 1]
            cell.viewModel = .init(
                foods: dailyMeal?.mealData.compactMap { $0.food } ?? [],
                mealtime: dailyMeal?.mealTime ?? .breakfast
            )
            
            return cell
        }
    }
}

extension OpenMainWidgetViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        OpenMainWidgetPresentController(
            presentedViewController: presented,
            presenting: presenting,
            topInset: viewControllerTopInset - (mainWidgetTopInsets[.modal] ?? 0)
        )
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        OpenMainWidgetPresentTransition()
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        OpenMainWidgetDismissTransition()
    }
}

// MARK: - Factory

extension OpenMainWidgetViewController {
    private func getCollectionViewCell() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.chevronDown(), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
        return button
    }
}
