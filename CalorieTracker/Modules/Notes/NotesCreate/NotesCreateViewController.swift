//
//  NotesEnterValueViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 07.01.2023.
//

import UIKit

final class NotesCreateViewController: UIViewController {
    var keyboardManager: KeyboardManagerProtocol = KeyboardManager()
    var handlerAllNotes: (() -> Void)?
    var needUpdate: (() -> Void)?
    
    private var bottomLayoutConstraint: NSLayoutConstraint?
    
    private lazy var headerView: NotesCreateHeader = .init(frame: .zero)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraint()
        configureKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        headerView.textViewBecomeFirstResponder()
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        needUpdate?()
        super.dismiss(animated: flag, completion: completion)
    }
    
    private func setupView() {
        headerView.complitionPhotoButton = { [weak self] in
            self?.showAlert()
        }
        
        headerView.complitionCloseButton = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        headerView.complitionAllNotesButton = { [weak self] in
            self?.dismiss(animated: true, completion: {
                self?.handlerAllNotes?()
            })
        }
        
        headerView.complitionDoneButton = { [weak self] in
            self?.saveNote()
            self?.dismiss(animated: true)
        }
    }
    
    private func setupConstraint() {
        view.addSubview(headerView)
        
        bottomLayoutConstraint = headerView.bottomAnchor
            .constraint(equalTo: view.bottomAnchor)
        bottomLayoutConstraint?.isActive = true
        headerView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview()
        })
    }
    
    private func configureKeyboard() {
        keyboardManager.bindToKeyboardNotifications(
            superview: view,
            bottomConstraint: bottomLayoutConstraint ?? .init(),
            bottomOffset: 0,
            animated: true
        )
    }
    
    private func showAlert() {
        let alert = UIAlertController(
            title: R.string.localizable.select(),
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            .init(
                title: R.string.localizable.galary(),
                style: .default,
                handler: { [weak self] _ in
                    self?.showImagePicker()
                }
            )
        )
        
        alert.addAction(
            .init(
                title: R.string.localizable.delete(),
                style: .destructive,
                handler: { [weak self] _ in
                    self?.headerView.photo = nil
                }
            )
        )
        
        alert.addAction(
            .init(
                title: R.string.localizable.cancel(),
                style: .cancel
            )
        )
        
        present(alert, animated: true)
    }
    
    private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    private func saveNote() {
        guard let text = headerView.text else {
            return
        }
        let estimation = headerView.selectedEstimation
        let id = UUID().uuidString
        let note = Note(
            id: id,
            date: Date(),
            text: text,
            estimation: estimation,
            imageUrl: try? headerView.photo?.save(at: .documentDirectory, pathAndImageName: id)
        )
        
        LocalDomainService().saveNotes(data: [note])
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

extension NotesCreateViewController: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        WidgetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            insets: .zero
        )
    }
}

extension NotesCreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            picker.dismiss(animated: true)
            return
        }
        self.headerView.photo = image
        picker.dismiss(animated: true)
    }
}
