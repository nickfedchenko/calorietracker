//
//  SearchTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.08.2022.
//

import UIKit

final class SearchView: ViewWithShadow {
    enum State {
        case smallNotEdit
        case largeNotEdit
        case edit(EditState)
    }
    
    enum EditState {
        case isEmpty
        case isNotEmpty
    }
    
    var didEndEditing: ((String) -> Void)?
    var didBeginEditing: ((String) -> Void)?
    var didChangeValue: ((String) -> Void)?
    
    var placeholderText: String = R.string.localizable.addFoodPlaceholder() {
        didSet {
            didChangeState()
        }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var state: State = .largeNotEdit {
        didSet {
            didChangeState()
        }
    }
    
    private let imagePlaceholder = R.image.searchTextField.search()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.searchTextField.search()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private(set) lazy var textField: InnerShadowTextField = {
        let textField = InnerShadowTextField()
        textField.font = R.font.sfProTextMedium(size: 17)
        textField.layer.cornerRadius = 16
        textField.layer.cornerCurve = .continuous
        textField.tintColor = R.color.foodViewing.basicPrimary()
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(didChangeTextValue),
            for: .editingChanged
        )
        return textField
    }()
    
    private lazy var leftView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.searchTextField.close(), for: .normal)
        button.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(Const.shadows)
        setupView()
        setupConstraints()
        didChangeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        textField.leftView = leftView
        textField.rightView = rightButton
        textField.leftViewMode = .whileEditing
    }
    
    private func setupConstraints() {
        addSubview(textField)
        leftView.addSubview(imageView)
        
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
            make.height.width.equalTo(24)
        }
        
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func didChangeState() {
        switch state {
        case .edit(let editState):
            self.shadowLayer.isHidden = true
            backgroundColor = .white
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText)
            textField.innerShadowColor = R.color.foodViewing.basicPrimary()
            textField.textAlignment = .left
            
            switch editState {
            case .isNotEmpty:
                textField.rightViewMode = .always
            case .isEmpty:
                textField.rightViewMode = .never
            }
        case .largeNotEdit:
            self.shadowLayer.isHidden = false
            textField.attributedPlaceholder = getPlaceholder(placeholderText)
            textField.innerShadowColor = .clear
            textField.textAlignment = .center
            textField.rightViewMode = .never
            backgroundColor = R.color.searchTextField.background()
        case .smallNotEdit:
            self.shadowLayer.isHidden = false
            textField.attributedPlaceholder = imagePlaceholder?.asAttributedString
            textField.innerShadowColor = .clear
            textField.textAlignment = .center
            textField.rightViewMode = .never
            backgroundColor = R.color.searchTextField.background()
        }
    }
    
    private func getPlaceholder(_ text: String) -> NSAttributedString {
        let image = R.image.searchTextField.search()!
        let font = R.font.sfProRoundedBold(size: 18)
        
        return text.attributedSring(
            [
                .init(
                    worldIndex: Array(0...text.split(separator: " ").count),
                    attributes: [.font(font)]
                )
            ],
            image: .init(image: image, font: font, position: .left)
        )
    }
    
    @objc private func didChangeTextValue() {
        guard let text = textField.text else { return }
        didChangeValue?(text)
        state = .edit(text.isEmpty ? .isEmpty : .isNotEmpty)
    }
    
    @objc private func didTapRightButton() {
        textField.text = ""
        didChangeValue?(textField.text ?? "")
        state = .edit(.isEmpty)
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        didBeginEditing?(textField.text ?? "")
        state = .edit((textField.text ?? "").isEmpty ? .isEmpty : .isNotEmpty)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        didEndEditing?(textField.text ?? "")
        state = .largeNotEdit
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        state = .edit(.isEmpty)
        return true
    }
}

// MARK: - Const

extension SearchView {
    struct Const {
        static let shadows: [Shadow] = [
            .init(
                color: R.color.searchTextField.shadowFirst() ?? .black,
                opacity: 0.25,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2
            ),
            .init(
                color: R.color.searchTextField.shadowSecond() ?? .black,
                opacity: 0.2,
                offset: CGSize(width: 0, height: 4),
                radius: 10
            )
        ]
    }
}
