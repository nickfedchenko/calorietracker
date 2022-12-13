//
//  SearchHistoryViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.11.2022.
//

import UIKit

final class SearchHistoryViewController: UIViewController {
    
    var complition: ((String) -> Void)?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = R.color.addFood.menu.isSelectedBorder()
        label.font = R.font.sfProDisplayBold(size: 22)
        label.text = "recent searches".uppercased()
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.separatorColor = R.color.addFood.separator()
        return view
    }()
    
    private var models: [String] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        models = UDM.searchHistory
    }
    
    private func setupView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        view.addSubviews(titleLabel, tableView)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(2)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
}

extension SearchHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = models[safe: indexPath.row] else { return }
        complition?(model)
    }
}

extension SearchHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        
        var configure = cell.defaultContentConfiguration()
        configure.text = models[indexPath.row]
        configure.textProperties.color = R.color.addFood.basicDark()!
        configure.textProperties.font = R.font.sfProTextRegular(size: 17)!
        
        cell.selectionStyle = .none
        cell.contentConfiguration = configure
        
        return cell
    }
}
