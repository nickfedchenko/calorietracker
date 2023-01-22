//
//  SelectedTagsCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 28.12.2022.
//

import AlignedCollectionViewFlowLayout
import UIKit

protocol SelectedTagsCellDelegate: AnyObject {
    func shouldDeleteFilter(tag: SelectedTagsCell.TagType)
}

final class SelectedTagsCell: UICollectionViewCell {
    static let identifier = String(describing: SelectedTagsCell.self)
    weak var delegate: SelectedTagsCellDelegate?
    
    enum TagType {
        case additionalTag(title: String, tag: AdditionalTag.ConvenientTag)
        case exceptionTag(title: String, tag: ExceptionTag.ConvenientExceptionTag, shouldUseAsCommonTag: Bool)
        case extraTag(ExtraSearchTags)
    }
    
    private var selectedTags: [TagType] = []
    
    private lazy var selectedTagsCollection: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .center)
        let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SelectedTagCell.self, forCellWithReuseIdentifier: SelectedTagCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(selectedTags: [SelectedTagsCell.TagType]) {
        self.selectedTags = selectedTags
        selectedTagsCollection.reloadData()
    }
    
    private func setupSubviews() {
        contentView.addSubview(selectedTagsCollection)
        selectedTagsCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension SelectedTagsCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        selectedTags.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectedTagCell.identifier,
            for: indexPath
        ) as? SelectedTagCell else {
            return UICollectionViewCell()
        }
        let tagType = selectedTags[indexPath.item]
        
        switch tagType {
        case .extraTag(let tag):
            cell.configure(with: tag.localizedTitle, index: indexPath.item)
        case let .exceptionTag(title: title, tag: _, shouldUseAsCommonTag: _):
            cell.configure(with: title, index: indexPath.item)
        case let .additionalTag(title: title, tag: _):
            cell.configure(with: title, index: indexPath.item)
        }
        cell.delegate = self
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 15)
        label.textAlignment = .left
        var tagTitle = ""
        let tag = selectedTags[indexPath.item]
        switch tag {
        case .extraTag(let tag):
            tagTitle = tag.localizedTitle
        case let .exceptionTag(title: title, tag: _, shouldUseAsCommonTag: _):
            tagTitle = title
        case let .additionalTag(title: title, tag: _):
            tagTitle = title
        }
        label.text = tagTitle
        label.sizeToFit()
        let width = label.bounds.width + 48
        return CGSize(width: width, height: 32)
    }
}

extension SelectedTagsCell: SelectedTagCellDelegate {
    func didTaptoRemoveTag(at index: Int) {
        let tagToRemove = selectedTags[index]
        selectedTags.remove(at: index)
        selectedTagsCollection.reloadSections(IndexSet(integer: 0))
        delegate?.shouldDeleteFilter(tag: tagToRemove)
    }
}
