//
//  NotesViewingViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 08.01.2023.
//

import UIKit

final class NotesViewingViewController: UIViewController {
    var keyboardManager: KeyboardManagerProtocol = KeyboardManager()
    var handlerAllNotes: (() -> Void)?
    
    var viewModel: NotesCellViewModel? {
        didSet {
            headerView.viewModel = viewModel
        }
    }
    
    private var bottomLayoutConstraint: NSLayoutConstraint?
    
    private lazy var headerView: NotesViewingHeaderView = .init(frame: .zero)
    
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
        addGestureRecognizer()
    }
    
    private func setupView() {
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
            .constraint(equalTo: view.bottomAnchor, constant: -80)
        bottomLayoutConstraint?.isActive = true
        headerView.snp.makeConstraints({ make in
            make.leading.trailing.equalToSuperview().inset(16)
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
    
    private func addGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapHeaderView))
        headerView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func saveNote() {
//        guard let text = headerView.text,
//              let estimation = headerView.selectedEstimation else {
//            return
//        }
//        let id = UUID().uuidString
//        let note = Note(
//            id: id,
//            date: Date(),
//            text: text,
//            estimation: estimation,
//            imageUrl: try? headerView.photo?.save(at: .applicationDirectory, pathAndImageName: id)
//        )
//
//        LocalDomainService().saveNotes(data: [note])
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    @objc private func didTapHeaderView() {
        guard headerView.state == .viewing else {
            return
        }
        headerView.gestureRecognizers?.forEach { $0.isEnabled = false }
        headerView.state = .edit
        
        headerView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
}

extension NotesViewingViewController: UIViewControllerTransitioningDelegate {
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
