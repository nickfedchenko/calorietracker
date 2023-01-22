//
//  FirstPageFormView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class FirstPageFormView: UIView {
    private lazy var nameLabel: UILabel = getNameLabel()
    private lazy var brandLabel: UILabel = getBrandLabel()
    private lazy var barcodeLabel: UILabel = getBarcodeLabel()
    private lazy var scannerButton: UIButton = getScannerButton()
    private lazy var scannerBackgroundView: ViewWithShadow = getScannerBackgroundView()
    private lazy var nameForm: FormView = getNameForm()
    private lazy var brandForm: FormView = getBrandForm()
    private lazy var barcodeForm: FormView = getBarcodeForm()
    
    var name: String? { nameForm.value }
    var brand: String? { brandForm.value }
    var barcode: String? { barcodeForm.value }
    
    var complition: ((@escaping (String) -> Void) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubviews(
            nameLabel,
            nameForm,
            brandLabel,
            brandForm,
            barcodeLabel,
            barcodeForm,
            scannerBackgroundView
        )
        
        scannerBackgroundView.addSubview(scannerButton)
    }
    
    private func setupConstraints() {
        scannerButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(9)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        
        nameForm.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(nameForm.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(8)
        }
        
        brandForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(brandLabel.snp.bottom).offset(4)
        }
        
        barcodeLabel.snp.makeConstraints { make in
            make.top.equalTo(brandForm.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(8)
        }
        
        barcodeForm.snp.makeConstraints { make in
            make.height.equalTo(48)
            make.leading.equalToSuperview()
            make.top.equalTo(barcodeLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview()
        }
        
        scannerBackgroundView.aspectRatio()
        scannerBackgroundView.snp.makeConstraints { make in
            make.height.equalTo(nameForm.snp.height)
            make.trailing.bottom.equalToSuperview()
            make.leading.equalTo(barcodeForm.snp.trailing).offset(12)
        }
    }
    
    @objc private func didTapBarcodeButton() {
        complition? { _ in
        }
    }
}

// MARK: - Factory

extension FirstPageFormView {
    private func getNameLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = R.string.localizable.createFormName()
        return label
    }
    
    private func getBrandLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = R.string.localizable.createFormBrand()
        return label
    }
    
    private func getBarcodeLabel() -> UILabel {
        let label = UILabel()
        label.font = R.font.sfProTextMedium(size: 17)
        label.textColor = R.color.foodViewing.basicGrey()
        label.text = R.string.localizable.createFormBarcode()
        return label
    }
    
    private func getScannerButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.addFood.tabBar.scan(), for: .normal)
        button.tintColor = R.color.foodViewing.basicSecondaryDark()
        button.addTarget(
            self,
            action: #selector(didTapBarcodeButton),
            for: .touchUpInside
        )
        return button
    }
    
    private func getScannerBackgroundView() -> ViewWithShadow {
        let view = ViewWithShadow(Const.shadows)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 12
        view.layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        return view
    }
    
    private func getNameForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .required(nil))
        return form
    }
    
    private func getBrandForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(width: .large, value: .optional)
        return form
    }
    
    private func getBarcodeForm() -> FormView<EmptyGetTitle> {
        let form = FormView<EmptyGetTitle>()
        form.model = .init(
            width: .large,
            value: .required(R.string.localizable.createFormBarcodePlaceholder())
        )
        return form
    }
}

extension FirstPageFormView {
    private struct Const {
        static let shadows: [Shadow] = [
            Shadow(
                color: R.color.createProduct.formFirstShadow() ?? .black,
                opacity: 0.15,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            Shadow(
                color: R.color.createProduct.formSecondShadow() ?? .black,
                opacity: 0.1,
                offset: CGSize(width: 0, height: 4),
                radius: 10
            )
        ]
    }
}
