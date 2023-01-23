//
//  NotesCollectionViewCell.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

final class NotesTableViewCell: UITableViewCell {
    var viewModel: NotesCellViewModel? {
        didSet {
            view.model = viewModel
        }
    }
    
    private lazy var view: NotesCellView = .init(frame: .zero)
    private lazy var shadowView: ViewWithShadow = .init(Const.shadows)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        shadowView.layer.cornerRadius = 16
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        contentView.addSubviews(shadowView, view)
        
        shadowView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
        
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
}

extension NotesTableViewCell {
    struct Const {
        static let shadows: [Shadow] = [
            Shadow(
                color: R.color.notes.noteAccent() ?? .black,
                opacity: 0.25,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            Shadow(
                color: R.color.notes.noteSecond() ?? .black,
                opacity: 0.2,
                offset: CGSize(width: 0, height: 4),
                radius: 10
            )
        ]
    }
}
