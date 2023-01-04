//
//  WaterKeyboardHeaderView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 23.12.2022.
//

import UIKit

protocol WaterKeyboardHeaderOutput: AnyObject {
    func saveModel(_ model: QuickAddModel)
}

final class WaterKeyboardHeaderView: UIView, KeyboardHeaderProtocol {
    private lazy var gradientBackgroundView: UIView = getGradientBackgroundView()
    private lazy var titleLabel: UILabel = getTitleLabel()
    private lazy var descriptionLabel: UILabel = getTitleLabel()
    private lazy var textField: UITextField = getTextField()
    private lazy var collectionView: UICollectionView = getCollectionView()
    private lazy var saveButton: BasicButtonView = .init(type: .save)
    
    private let cellTypes: [TypeQuickAdd] = [.cup, .bottle, .bottleSport, .jug]
    
    private var firstDraw = true
    private var model: QuickAddModel?
    private var selectedType: TypeQuickAdd? {
        didSet {
            checkSaveButton()
        }
    }
    
    var didTapClose: (() -> Void)?
    var didChangeValue: ((Double) -> Void)?
    weak var output: WaterKeyboardHeaderOutput?
    
    init(_ title: String) {
        super.init(frame: .zero)
        registerCell()
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard firstDraw, collectionView.frame != .zero else { return }
        setupGradient()
        firstDraw = false
    }
    
    private func registerCell() {
        collectionView.register(UICollectionViewCell.self)
        collectionView.register(QuickAddWaterCollectionViewCell.self)
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 36
        layer.maskedCorners = .topCorners
        
        layer.masksToBounds = true
        
        titleLabel.text = R.string.localizable.keyboardWaterTitle()
        descriptionLabel.text = R.string.localizable.keyboardWaterDescription()
        
        saveButton.active = false
        
        saveButton.addTarget(
            self,
            action: #selector(didTapSaveButton),
            for: .touchUpInside
        )
        
        textField.addTarget(
            self,
            action: #selector(didChangeTextFieldValue),
            for: .editingChanged
        )
    }
    
    private func setupConstraints() {
        addSubview(gradientBackgroundView)
        gradientBackgroundView.addSubviews(
            titleLabel,
            collectionView,
            descriptionLabel,
            textField,
            saveButton
        )
        
        gradientBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalToSuperview().offset(39)
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        textField.aspectRatio(0.171)
        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        saveButton.aspectRatio(0.171)
        saveButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(textField.snp.bottom).offset(18)
            make.bottom.equalToSuperview().offset(-18)
        }
    }
    
    private func setupGradient() {
        let gradientLayer = GradientLayer(.init(
                bounds: bounds,
                colors: Const.gradientColors,
                axis: .vertical(.top),
                locations: [0, 1]
        ))
        
        gradientBackgroundView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func checkSaveButton() {
        guard let text = textField.text,
                let value = Int(text),
              let type = selectedType else {
            saveButton.active = false
            return
        }
        model = .init(type: type, value: value)
        saveButton.active = true
    }
    
    @objc private func didTapCloseButton() {
        self.didTapClose?()
    }
    
    @objc private func didTapSaveButton() {
        guard let model = model else {
            self.didTapClose?()
            return
        }
        output?.saveModel(model)
        self.didTapClose?()
    }
    
    @objc private func didChangeTextFieldValue() {
        checkSaveButton()
    }
}

extension WaterKeyboardHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? QuickAddWaterCollectionViewCell else { return }
        collectionView
            .visibleCells
            .compactMap { $0 as? QuickAddWaterCollectionViewCell }
            .forEach { $0.isSelectedCell = false }
        
        cell.isSelectedCell = true
        self.selectedType = cell.type
    }
}

extension WaterKeyboardHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: QuickAddWaterCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.type = cellTypes[safe: indexPath.row]
        return cell
    }
}

extension WaterKeyboardHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 64, height: 64)
    }
}

// MARK: - Factory

extension WaterKeyboardHeaderView {
    private func getGradientBackgroundView() -> UIView {
        let view = UIView()
        return view
    }
    
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.keyboardHeader.weightClose(), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCloseButton),
            for: .touchUpInside
        )
        return button
    }
    
    private func getTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProDisplaySemibold(size: 28.fontScale())
        label.textColor = R.color.keyboardHeader.waterPrimary()
        label.textAlignment = .center
        return label
    }
    
    private func getImageView() -> UIImageView {
        let view = UIImageView()
        view.image = R.image.keyboardHeader.weightFirst()
        return view
    }
    
    private func getTextField() -> UITextField {
        let textField = InnerShadowTextField()
        textField.innerShadowColor = R.color.keyboardHeader.topGradient()
        textField.backgroundColor = .white
        textField.layer.cornerCurve = .continuous
        textField.layer.cornerRadius = 16
        textField.keyboardType = .decimalPad
        textField.keyboardAppearance = .light
        textField.font = R.font.sfProDisplaySemibold(size: 28)
        textField.textColor = R.color.keyboardHeader.purpleDark()
        textField.tintColor = R.color.keyboardHeader.purple()
        textField.textAlignment = .center
        textField.clipsToBounds = true
        return textField
    }
    
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = ContentFittingCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }
}

extension WaterKeyboardHeaderView {
    private struct Const {
        static let gradientColors = [
            R.color.keyboardHeader.topGradient(),
            R.color.keyboardHeader.bottomGradient()
        ]
    }
}
