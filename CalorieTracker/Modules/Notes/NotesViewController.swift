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

final class NotesViewController: CTViewController {
    var presenter: NotesPresenterInterface?
    
    private lazy var tableView: UITableView = getTableView()
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
        tableView.contentInset = .init(
            top: topView.frame.height + 10,
            left: 0,
            bottom: bottomView.frame.height + 10,
            right: 0
        )
    }
    
    private func registerCell() {
        tableView.register(UITableViewCell.self)
        tableView.register(NotesTableViewCell.self)
    }
    
    private func setupView() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
        view.backgroundColor = R.color.notes.background()
        
        presenter?.updateNotes()
    }
    
    private func setupConstraints() {
        view.addSubviews(
            tableView,
            topView,
            bottomView,
            closeButton,
            titleLabel
        )
        
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
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
        tableView.reloadData()
    }
}

// MARK: - TableView Delegate

extension NotesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTapCell(indexPath)
    }
}

// MARK: - TableView DataSource

extension NotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItemsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = presenter?.getNotesCell(tableView, indexPath: indexPath) else {
            let defaultCell: UITableViewCell = tableView.dequeueReusableCell(for: indexPath)
            return defaultCell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter?.getHeight(view.frame.width) ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { _, _, completion in
                self.presenter?.deleteNote(indexPath)
                tableView.deleteRows(at: [indexPath], with: .left)
                completion(true)
            }
        )

        action.image = R.image.notes.deleteCell()
        action.backgroundColor = R.color.notes.background()
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
}

// MARK: - Factory

extension NotesViewController {
    private func getTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        tableView.layer.masksToBounds = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
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
