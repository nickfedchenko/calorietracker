//
//  RateUsScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 10.03.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import StoreKit
import UIKit

protocol RateUsScreenViewControllerInterface: AnyObject {

}

class RateUsScreenViewController: UIViewController {
    var presenter: RateUsScreenPresenterInterface?
    private let images: [UIImage?] = [
        R.image.review1(),
        R.image.review2(),
        R.image.review3(),
        R.image.review4(),
        R.image.review5()
    ]
    
    private lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ReviewCell.self, forCellWithReuseIdentifier: ReviewCell.identifier)
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.clipsToBounds = false
        return collectionView
    }()
    
    private let likeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.likeReviewImage()
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedMedium(size: 33)
        label.textColor = UIColor(hex: "12834D")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = R.string.localizable.rateUsTitle()
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProRoundedBold(size: 18)
        label.textColor = UIColor(hex: "547771")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = R.string.localizable.rateUsSubtitle()
        return label
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(hex: "168F55")
        pageControl.pageIndicatorTintColor = UIColor(hex: "C7C7C7")
        return pageControl
    }()
    
    private lazy var continueCommonButton: CommonButton = .init(
        style: .filled,
        text: R.string.localizable.onboardingFourthEmotionalSupportSystemButton().uppercased()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackBarButtonItem()
        setupSubviews()
        view.backgroundColor = UIColor(hex: "F3FFFE")
        continueCommonButton.addAction(
            UIAction { [weak self] _ in
                self?.presenter?.didTapNextButton()
            },
            for: .touchUpInside
        )
        
        guard
            !["US", "GB", "CA", "AU"].contains(Locale.current.regionCode ?? "US")
        &&
        !(Locale.current.languageCode ?? "en_US").contains("en") else {
            return
        }
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    private func setupSubviews() {
        view.addSubviews(titleLabel, subtitleLabel, likeImage, collectionView, continueCommonButton, pageControl)
        
        likeImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(112.fitH)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(likeImage.snp.bottom).offset(28.5)
            make.leading.trailing.equalToSuperview().inset(32)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(43.fitH)
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40.fitW)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(66.fitH)
            make.height.equalTo(262)
        }
        
        continueCommonButton.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(80.fitH)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(24)
        }
    }
}

extension RateUsScreenViewController: RateUsScreenViewControllerInterface {

}

extension RateUsScreenViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReviewCell.identifier,
            for: indexPath
        ) as? ReviewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: images[indexPath.item])
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 80.fitW, height: 262)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
       10
    }
    
    func collectionView(
        _ collectionView: UICollectionView, 
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let oneItemOffset = view.bounds.width - 80.fitW
        let offsetX = scrollView.contentOffset.x
        pageControl.currentPage = Int(offsetX / (oneItemOffset - 10))
    }
}
