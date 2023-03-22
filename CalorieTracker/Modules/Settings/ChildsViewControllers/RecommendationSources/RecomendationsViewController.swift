//
//  RecomendationsViewController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 16.03.2023.
//

import UIKit

final class RecommendationsViewController: UIViewController {
    
    // MARK: - Property list
    private let recommendationsTitleLabel = UILabel()
    private let recommendationsDescriptionLabel = UILabel()
    private var blurRadiusDriver: UIViewPropertyAnimator?
    private let backButton: UIButton = {
        let button = UIButton()
//        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setAttributedTitle(
            R.string.localizable.settingsApp().uppercased().attributedSring(
                [
                    StringSettingsModel(
                        worldIndex: [0, 1],
                        attributes: [
                            .font(R.font.sfProDisplaySemibold(size: Locale.current.languageCode == "ru" ? 19 : 22)),
                            .color(R.color.foodViewing.basicGrey())
                        ]
                    )
                ]
            ),
            for: .normal
        )
        button.setImage(R.image.settings.leftChevron(), for: .normal)
        button.titleEdgeInsets.left = 25
        
        return button
    }()
    private let recommendationsTableView = UITableView(frame: .zero, style: .grouped)
    private let mainScrollView = UIScrollView()
    private let scrollContentView = UIView()
    
    private let footerBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "F3FFFE").withAlphaComponent(0.9)
        view.backgroundColor = .clear
        return view
    }()
    
    let footerBlur = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
    
    var viewModel: RecommendationsViewModel?
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureVMCallbacks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        remakeConstraintForTable()
        reinitBlurView()
    }
    
    private func configureUI() {
        addSubViews()
        configureView()
        setupConstraints()
        configureRecomTableView()
        configureCloseButton()
        configureScreenTitle()
        configureScreenDescription()
    }
    
    private func addSubViews() {
        view.addSubview(recommendationsTitleLabel)
        view.addSubview(mainScrollView)
        view.addSubview(footerBackground)
        footerBackground.addSubview(footerBlur)
        footerBlur.contentView.addSubview(backButton)
        mainScrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(recommendationsDescriptionLabel)
        scrollContentView.addSubview(recommendationsTableView)
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(hex: "F3FFFE")
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    // MARK: - CONFIGURE TITLE
    private func configureScreenTitle() {
        recommendationsTitleLabel.numberOfLines = 0
        recommendationsTitleLabel.textColor = UIColor(hex: "0C695E")
        
        recommendationsTitleLabel.text = R.string.localizable.recommendationsTitle()
        recommendationsTitleLabel.font = R.font.sfProRoundedBold(size: 20)
        recommendationsTitleLabel.textAlignment = .left
    }
    
    // MARK: - CONFIGURE DESCRIPTION
    private func configureScreenDescription() {
        recommendationsDescriptionLabel.text = R.string.localizable.recommendationsDescription()
        recommendationsDescriptionLabel.font = R.font.sfProTextMedium(size: 16)
        recommendationsDescriptionLabel.textAlignment = .left
        recommendationsDescriptionLabel.numberOfLines = 0
        recommendationsDescriptionLabel.textColor = UIColor(hex: "192621")
    }
    
    private func configureCloseButton() {
        backButton.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
    }
    
    @objc private func closeButtonPressed() {
        dismiss(animated: true) { [weak self] in
            self?.releaseBlurAnimation()
        }
    }
    
    // MARK: - CONFIGURE TABLE VIEW
    private func configureRecomTableView() {
        registerCells()
        recommendationsTableView.delegate = self
        recommendationsTableView.dataSource = self
        recommendationsTableView.separatorStyle = .none
        recommendationsTableView.showsVerticalScrollIndicator = false
        recommendationsTableView.backgroundColor = .clear
        recommendationsTableView.isScrollEnabled = false
        mainScrollView.contentInset.bottom = 20
    }
    
    private func registerCells() {
        recommendationsTableView.register(
            RecommendationsTableViewCell.self,
            forCellReuseIdentifier: RecommendationsTableViewCell.identifier
        )
    }
    
    private func remakeConstraintForTable() {
        recommendationsTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(30)
            make.height.equalTo(recommendationsTableView.contentSize.height)
        }
    }
    
    // MARK: - CALLBACKS
    private func configureVMCallbacks() {
        viewModel?.onCellPressedCallback = { urlString in
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - CREATING HEADER VIEW
    private func createHeaderForSectionView(with title: String) -> UIView {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.font = R.font.sfProTextMedium(size: 18)
        titleLabel.textColor = UIColor(hex: "0C695E")
        titleLabel.text = title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(5)
        }
        return headerView
    }
    
    func releaseBlurAnimation() {
        blurRadiusDriver?.stopAnimation(true)
    }
    
    func reinitBlurView() {
        blurRadiusDriver?.stopAnimation(true)
        blurRadiusDriver?.finishAnimation(at: .current)
        
        footerBlur.effect = nil
        blurRadiusDriver = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: {
            self.footerBlur.effect = UIBlurEffect(style: .light)
        })
        blurRadiusDriver?.fractionComplete = 0.2
    }
}

extension RecommendationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let number = viewModel?.getNumberOfSections() ?? 1
//        viewModel?.getNumberOfSections() ?? 1
        return number
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerTitle = viewModel?.getTitleForHeaderInSection(section: section) ?? ""
        let header = createHeaderForSectionView(with: headerTitle)
        if section == 1 {
            (header.subviews.first as? UILabel)?.font = R.font.sfProTextBold(size: 20)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfItemInSection(section: section) ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendationsTableViewCell.identifier,
                                                       for: indexPath) as? RecommendationsTableViewCell,
              let model = viewModel?.getSectionModel(at: indexPath) else { return UITableViewCell() }
        cell.configure(with: model, row: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.onTableCellPressed(section: indexPath.section, row: indexPath.row)
    }
}

// MARK: - Setup constraints
extension RecommendationsViewController {
    
    private func setupConstraints() {
        
        recommendationsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(40)
            make.bottom.equalTo(mainScrollView.snp.top).inset(-24)
        }
        
        mainScrollView.snp.makeConstraints { make in
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }
        
        recommendationsDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(recommendationsTableView.snp.top).inset(-24)
        }
        
        recommendationsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0)
        }
        
        footerBackground.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(112)
        }
        
        footerBlur.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}

