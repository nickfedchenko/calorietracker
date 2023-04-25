//
//  SelectedFoodCellsViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 27.11.2022.
//

import UIKit

final class PassThroughScrollView: UIScrollView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height).contains(point) {
            return subviews.first?.hitTest(point, with: event)
        } else {
            return superview?.subviews.first?.hitTest(point, with: event)
        }
    }
}

final class SelectedFoodCellsViewController: UIViewController {
    var router: SelectedFoodCellsRouterInterface?
    var didChangeSelectedFoods: (([Food]) -> Void)?
    
    private lazy var scrollView: PassThroughScrollView = {
        let view = PassThroughScrollView()
        view.backgroundColor = .clear
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.foodViewing.basicPrimary()?.withAlphaComponent(0.25)
        view.alpha = 0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let foodCollectionViewController = FoodCollectionViewController(.contentFitting)
    
    private var foods: [Food] {
        didSet {
            if foods.isEmpty {
                closeVC()
            } else {
                foodCollectionViewController.collectionView.reloadSections(IndexSet(integer: 0))
            }
        }
    }
    
    init(_ foods: [Food]) {
        self.foods = foods
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToHideTapped)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.contentInset = .init(
            top: view.safeAreaInsets.top,
            left: 0,
            bottom: view.safeAreaInsets.bottom,
            right: 0
        )
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 0
        } completion: { _ in
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    @objc private func tapToHideTapped(sender: UITapGestureRecognizer) {
        let location = sender.location(in: scrollView)
        print(containerView.frame)
        print(location)
        guard !containerView.frame.contains(location) else {
            return
        }
        dismiss(animated: true)
    }
    
    func getFoods() -> [Food] {
        return foods
    }
    
    func updateFoods(with food: Food) {
        if let index = foods.firstIndex(where: { $0.id == food.id }) {
            foods[index] = food
        }
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        
        foodCollectionViewController.isScrollEnabled = false
        foodCollectionViewController.delegate = self
        foodCollectionViewController.dataSource = self
    }
    
    private func setupConstraints() {
        view.addSubviews(dimmingView,scrollView, closeButton)
        
        containerView.addSubviews(foodCollectionViewController.view)
        scrollView.addSubviews(containerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        foodCollectionViewController.view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-92)
        }
        
        containerView.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.top.equalToSuperview()
            make.trailing.trailing.equalToSuperview()
            make.width.equalTo(view)
            make.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(containerView.snp.bottom).offset(-20).priority(.low)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    private func closeVC() {
        didChangeSelectedFoods?(foods)
        router?.close()
    }
    
    @objc private func didTapCloseButton() {
        closeVC()
    }
}

// MARK: - FoodCollection Delegate

extension SelectedFoodCellsViewController: FoodCollectionViewControllerDelegate {
    func didSelectCell(_ type: Food) {
        switch type {
        case .product(let product, _, _):
            router?.openProductViewController(product)
        case .dishes(let dish, customAmount: _):
            router?.openDishViewController(dish)
        default:
            return
        }
    }
}

// MARK: - FoodCollection DataSource

extension SelectedFoodCellsViewController: FoodCollectionViewControllerDataSource {
    func foodsOverAll() -> [Food] {
        foods
    }
    
    func foodCellModel(_ indexPath: IndexPath) -> FoodCellViewModel? {
        return .init(
            cellType: .table,
            food: foods[safe: indexPath.row],
            buttonType: .delete,
            subInfo: nil,
            colorSubInfo: nil,
            isFromSelectedFoodController: true
        )
    }
    
    func cell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FoodCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.viewModel = foodCellModel(indexPath)
        cell.didTapButton = { food, _ in
            guard let index = self.foods.firstIndex(where: { $0 == food }) else { return }
            self.foods.remove(at: index)
//            self.foodCollectionViewController.collectionView.performBatchUpdates {
//                self.foodCollectionViewController.collectionView
//                    .deleteItems(at: [IndexPath(row: index, section: 0)])
//            }
          
        }
        return cell
    }
    
    func foodsCount() -> Int {
        foods.count
    }
}
