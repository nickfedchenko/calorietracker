//
//  SelectImageView.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 11.12.2022.
//

import UIKit

final class SelectImageView: UIView {
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        return view
    }()
    
    private let viewController: UIViewController
    
    private var image: UIImage? {
        didSet {
            didChangeImage()
        }
    }
    
    init(_ vc: UIViewController) {
        self.viewController = vc
        super.init(frame: .zero)
        setupView()
        setupConstraints()
        setupGestureRecognizer()
        didChangeImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerCurve = .continuous
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = R.color.foodViewing.basicSecondaryDark()?.cgColor
        backgroundColor = R.color.foodViewing.basicGrey()
    }
    
    private func setupConstraints() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func didChangeImage() {
        guard let image = image else {
            imageView.contentMode = .center
            imageView.image = R.image.createProduct.camera()
            return
        }
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
    }
    
    private func setupGestureRecognizer() {
        let gr = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        self.addGestureRecognizer(gr)
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: "Select",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            .init(
                title: "Galary",
                style: .default,
                handler: { [weak self] _ in
                    self?.showImagePicker()
                }
            )
        )
        
        alert.addAction(
            .init(
                title: "Delete",
                style: .destructive,
                handler: { [weak self] _ in
                    self?.image = nil
                }
            )
        )
        
        alert.addAction(
            .init(
                title: "Cancel",
                style: .cancel
            )
        )
        
        viewController.present(alert, animated: true)
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        viewController.present(imagePicker, animated: true)
    }
    
    @objc private func didTapImageView() {
        showAlert()
    }
}

extension SelectImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        self.image = image
        picker.dismiss(animated: true)
    }
}
