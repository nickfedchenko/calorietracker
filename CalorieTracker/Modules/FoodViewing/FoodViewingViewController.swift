//
//  FoodViewingViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 15.11.2022.
//  Copyright © 2022 Mov4D. All rights reserved.
//

import UIKit

protocol FoodViewingViewControllerInterface: AnyObject {

}

final class FoodViewingViewController: UIViewController {
    var presenter: FoodViewingPresenterInterface?
    
    // MARK: - Private
    
    private lazy var mainScrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.sfProDisplayBold(size: 24)
        label.textColor = R.color.foodViewing.basicPrimary()
        label.numberOfLines = 0
        label.text = "Apple"
        return label
    }()
    
    private lazy var headerImageView = HeaderImageView()
    
    // MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavBar()
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        view.backgroundColor = R.color.foodViewing.background()
        
        headerImageView.didTapLike = { value in
            print(value)
        }
    }
    
    private func addSubviews() {
        mainScrollView.addSubviews(titleLabel, headerImageView)
        
        view.addSubviews(mainScrollView)
    }
    
    private func setupConstraints() {
        mainScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(32)
        }
        
        headerImageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo(headerImageView.snp.width).multipliedBy(0.65)
            make.bottom.equalToSuperview()
        }
    }
    
    private func hideNavBar() {
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - ViewController Interface

extension FoodViewingViewController: FoodViewingViewControllerInterface {

}
