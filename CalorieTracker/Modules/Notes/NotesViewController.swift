//
//  NotesViewController.swift
//  CIViperGenerator
//
//  Created by Mov4D on 04.01.2023.
//  Copyright © 2023 Mov4D. All rights reserved.
//

import UIKit

protocol NotesViewControllerInterface: AnyObject {
    func reload()
}

final class NotesViewController: UIViewController {
    var presenter: NotesPresenterInterface?
    
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var topView: UIView = getBlurView()
    private lazy var bottomView: UIView = getBlurView()
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var titleLabel: UILabel = getTitleLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerCell()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.contentInset = .init(
            top: topView.frame.height + 10,
            left: 0,
            bottom: bottomView.frame.height + 10,
            right: 0
        )
    }
    
    private func registerCell() {
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(NotesCollectionViewCell.self)
    }
    
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
        view.backgroundColor = R.color.notes.background()
        
        presenter?.updateNotes()
    }
    
    private func setupConstraints() {
        view.addSubviews(
            collectionView,
            topView,
            bottomView,
            closeButton,
            titleLabel
        )
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(56)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-40)
        }
        
        closeButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(64)
            make.centerX.equalToSuperview()
            make.top.equalTo(bottomView.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(topView.snp.bottom).offset(-24)
        }
    }
    
    @objc private func didTapCloseButton() {
        presenter?.didTapCloseButton()
    }
}

extension NotesViewController: NotesViewControllerInterface {
    func reload() {
        collectionView.reloadData()
    }
}

// MARK: - CollectionView Delegate

extension NotesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTapCell(indexPath)
    }
}

// MARK: - CollectionView DataSource

extension NotesViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return presenter?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = presenter?.getNotesCell(collectionView, indexPath: indexPath) else {
            let defaultCell: UICollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            return defaultCell
        }
        return cell
    }
}

// MARK: - CollectionView FlowLayout

extension NotesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return presenter?.getSize(view.frame.width) ?? .zero
    }
}

// MARK: - Factory

extension NotesViewController {
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }
    
    private func getBlurView() -> UIView {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.notes.noteSecond()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 28.fontScale())
        label.textColor = R.color.notes.noteAccent()
        label.text = "ALL NOTES"
        return label
    }
}
