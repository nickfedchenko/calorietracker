//
//  SearchTextField.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 19.08.2022.
//

import UIKit

final class SearchView: ViewWithShadow {
    enum Mode {
        case disabled
        case enabled
    }
    
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
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
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
    
    var isStatic = false
    
    init() {
        super.init(Const.shadows)
        setupView()
        setupConstraints()
        didChangeState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    func turnOffTextFieldInteractions() {
        textField.isUserInteractionEnabled = false
    }
    
    // MARK: - Private methods
    
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
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if rightButton.frame.contains(point) {
            return rightButton
        } else {
            return super.hitTest(point, with: event)
        }
    }
    
    private func didChangeState() {
        switch state {
        case .edit(let editState):
            self.shadowLayer.isHidden = true
            backgroundColor = .white
            textField.attributedPlaceholder = NSAttributedString(string: placeholderText)
            textField.innerShadowColors = [UIColor(hex: "0C695E"), UIColor(hex: "0C695E")]
            textField.textAlignment = .left
            switch editState {
            case .isNotEmpty:
                textField.rightViewMode = .always
            case .isEmpty:
                textField.rightViewMode = .never
            }
        case .largeNotEdit:
            if !isStatic {
                self.shadowLayer.isHidden = false
                textField.attributedPlaceholder = getPlaceholder(placeholderText)
                textField.innerShadowColors = []
                textField.textAlignment = .center
                textField.rightViewMode = .never
                backgroundColor = R.color.searchTextField.background()
            } else {
                if (textField.text ?? "").isEmpty {
                    self.shadowLayer.isHidden = false
                    textField.attributedPlaceholder = getPlaceholder(placeholderText)
                    textField.innerShadowColors = []
                    textField.textAlignment = .center
                    textField.rightViewMode = .never
                    textField.leftViewMode = .never
                    backgroundColor = R.color.searchTextField.background()
                } else {
                    self.shadowLayer.isHidden = true
                    textField.innerShadowColors = [UIColor(hex: "0C695E"), UIColor(hex: "0C695E")]
                    textField.textAlignment = (textField.text ?? "").isEmpty ? .center : .left
                    textField.rightViewMode = (textField.text ?? "").isEmpty ? .never : .always
                    textField.leftViewMode = .always
                    backgroundColor = R.color.searchTextField.background()
                }
            }
        case .smallNotEdit:
            self.shadowLayer.isHidden = false
            textField.attributedPlaceholder = imagePlaceholder?.asAttributedString
            textField.innerShadowColors = []
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
        state = isStatic ? .largeNotEdit : .edit(.isEmpty)
        didChangeValue?(textField.text ?? "")
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
                color: UIColor(hex: "06BBBB"),
                opacity: 0.2,
                offset: CGSize(width: 0, height: 4),
                radius: 10,
                spread: 0
            ),
            .init(
                color: UIColor(hex: "123E5E"),
                opacity: 0.25,
                offset: CGSize(width: 0, height: 0.5),
                radius: 2,
                spread: 0
            )
        ]
    }
}
