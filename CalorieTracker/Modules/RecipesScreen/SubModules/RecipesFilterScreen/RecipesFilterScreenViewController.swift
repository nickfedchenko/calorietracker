//
//  RecipesFilterScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 27.12.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import AlignedCollectionViewFlowLayout
import UIKit

protocol RecipesFilterScreenViewControllerInterface: AnyObject {
    func updateCollection()
    func selectTagsInitially(with indexPaths: [IndexPath])
}

class RecipesFilterScreenViewController: UIViewController {
    var presenter: RecipesFilterScreenPresenterInterface?
    
   
    private let blurView = UIVisualEffectView(effect: nil)
    private var blurRadiusDriver: UIViewPropertyAnimator?
    private let footerContainer: UIView = {
       let view = UIView()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: "F3FFFE", alpha: 1).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.2)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.locations = [0, 0.8]
        view.layer.addSublayer(gradientLayer)
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.chevronLeft(), for: .normal)
        return button
    }()
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        let attrTitle = NSAttributedString(
            string: "Apply".localized,
            attributes: [
                .font: R.font.sfProRoundedBold(size: 22) ?? .systemFont(ofSize: 22),
                .foregroundColor: UIColor.white
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(hex: "0C695E")
        button.layer.borderColor = UIColor(hex: "1BA17C").cgColor
        button.layer.borderWidth = 1
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(R.image.resetFiltersIcon(), for: .normal)
        return button
    }()
    
    private lazy var tagsCollectionView: DynamicCollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.identifier)
        collectionView.register(
            SearchFiltersScreenCollectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchFiltersScreenCollectionHeader.identifier
        )
        collectionView.register(FiltersScreenTopCell.self, forCellWithReuseIdentifier: FiltersScreenTopCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 126, right: 16)
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupSubviews()
        setupActions()
    }
    
    private func setupAppearance() {
        view.backgroundColor = UIColor(hex: "F3FFFE")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reinitBlurView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.selectTagsInitially(with: self?.presenter?.getIndicesOfSelectedTags() ?? [])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        footerContainer.layer.sublayers?.first?.frame = footerContainer.bounds
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimation()
    }
    
    deinit {
        print("Filters deinited")
    }
    
    private func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        blurView.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.blurView.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.2
    }
    
    private func stopAnimation() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
    }
    
    private func setupActions() {
        resetButton.addTarget(self, action: #selector(clearAllTags), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    private func setupSubviews() {
        view.addSubview(tagsCollectionView)
        view.addSubview(footerContainer)
        footerContainer.addSubview(blurView)
        blurView.contentView.addSubviews(backButton, applyButton, resetButton)
        tagsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        footerContainer.snp.makeConstraints { make in
            make.height.equalTo(126)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(32)
        }
        
        applyButton.snp.makeConstraints { make in
            make.width.equalTo(222)
            make.height.equalTo(64)
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        resetButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.centerY.equalTo(applyButton)
            make.trailing.equalToSuperview().inset(33)
        }
    }
    
    @objc private func applyButtonTapped() {
        presenter?.applyButtonTapped()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func clearAllTags() {
        if let indexesOfSelectedTags = tagsCollectionView.indexPathsForSelectedItems {
            indexesOfSelectedTags.forEach { [weak self] in
                self?.tagsCollectionView.deselectItem(at: $0, animated: true)
                self?.presenter?.didDeselectTag(at: $0)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension RecipesFilterScreenViewController: RecipesFilterScreenViewControllerInterface {
    func updateCollection() {
        tagsCollectionView.reloadData()
    }
    
    func selectTagsInitially(with indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            tagsCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }
}

extension RecipesFilterScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.getNumberOfSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.getNumberOfItems(at: section) ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.section > 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagCell.identifier,
                for: indexPath
            ) as? TagCell,
                  let tagTitle = presenter?.getTagTitle(at: indexPath) else {
                return UICollectionViewCell()
            }
            cell.configure(with: tagTitle)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FiltersScreenTopCell.identifier,
                for: indexPath
            ) as? FiltersScreenTopCell else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        if section == 0 {
            return  UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        } else {
            return  UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    )
    -> CGSize {
        if indexPath.section > 0 {
            let label = UILabel()
            let title = presenter?.getTagTitle(at: indexPath) ?? ""
            label.font = R.font.sfProTextMedium(size: 15)
            label.textAlignment = .center
            label.text = title
            label.sizeToFit()
            let bounds = label.bounds.insetBy(dx: -8, dy: -8)
            return bounds.size
        } else {
            return CGSize(width: collectionView.bounds.width, height: 24)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        presenter?.didDeselectTag(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectTag(at: indexPath)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SearchFiltersScreenCollectionHeader.identifier,
                for: indexPath
            )
            guard let typedHeader = header as? SearchFiltersScreenCollectionHeader,
                  let title = presenter?.getTitleForSection(at: indexPath) else {
                return header
            }
            typedHeader.configure(with: title)
            return typedHeader
        default:
            assert(false, "wrong kind type")
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 24)
    }
}
