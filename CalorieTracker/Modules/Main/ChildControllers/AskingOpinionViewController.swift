//
//  AskingOpinionViewController.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 10.03.2023.
//

import Amplitude
import UIKit
import MessageUI

final class AskingOpinionViewController: UIViewController {
    var shouldShowMailController: (() -> Void)?
    var shouldOpenWriteReviewPage: (() -> Void)?
    
    let container: ViewWithShadow = {
        let view = ViewWithShadow(Constants.shadows)
        view.layer.cornerCurve = .continuous
        view.layer.cornerRadius = 40
        view.layer.maskedCorners = [.topCorners]
        view.layer.backgroundColor = UIColor.white.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.sfProRoundedHeavy(size: 24)
        label.textColor = UIColor(hex: "0C695E")
        label.numberOfLines = 0
        label.text = R.string.localizable.askOpinionTitle()
        return label
    }()
    
    private let lowerTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = R.font.sfProRoundedHeavy(size: 24)
        label.textColor = UIColor(hex: "0C695E")
        label.numberOfLines = 0
        label.text = R.string.localizable.askOpinionSubtitle()
        return label
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.reviewsLogo()
        return imageView
    }()
    
    private let fruitsImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.fruitsAndVegetables()
        return imageView
    }()
    
    private lazy var writeReviewButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.cornerCurve = .circular
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hex: "B0B5B5").cgColor
        button.setImage(R.image.reviewsYes(), for: .normal)
        let attrTitle = NSAttributedString(
            string: R.string.localizable.reviewsWriteAReview(),
            attributes: [
                .font: R.font.sfProTextBold(size: 17) ?? .systemFont(ofSize: 17),
                .foregroundColor: UIColor(hex: "192621")
            ]
        )
        button.imageView?.snp.remakeConstraints { make in
            make.height.width.equalTo(48)
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(6)
        }
        button.setAttributedTitle(attrTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapToReviewButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var writeUsMail: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.cornerCurve = .circular
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(hex: "B0B5B5").cgColor
        button.setImage(R.image.reviewsNo(), for: .normal)
        button.imageView?.snp.remakeConstraints { make in
            make.height.width.equalTo(48)
            make.top.bottom.equalToSuperview().inset(6)
            make.leading.equalToSuperview().offset(6)
        }
        let attrTitle = NSAttributedString(
            string: R.string.localizable.reviewsSendUsFeedback(),
            attributes: [
                .font: R.font.sfProTextBold(size: 17) ?? .systemFont(ofSize: 17),
                .foregroundColor: UIColor(hex: "192621")
            ]
        )
        button.setAttributedTitle(attrTitle, for: .normal)
        button.addTarget(self, action: #selector(didTapWriteToUsButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var pullToCloseImage: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "B0B5B5")
        view.layer.cornerRadius = 3
        view.layer.cornerCurve = .circular
        view.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.height.equalTo(6)
        }
        view.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(didPulledContainer(sender:)))
        )
        return view
    }()
    
    private lazy var dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "004646").withAlphaComponent(0.25)
        view.alpha = 0
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(dismissTapGesture(sender:)))
        )
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateAppearing()
        UDM.didShowAskingOpinionDate = Date()
    }
    
    @objc private func dismissTapGesture(sender: UITapGestureRecognizer) {
        animateDisappearing(completion: nil)
    }
    
    @objc private func didTapToReviewButton() {
        animateDisappearing { [weak self] in
            self?.shouldOpenWriteReviewPage?()
        }
        Amplitude.instance().logEvent("reviewScreenOpen", withEventProperties: ["result": "like"])
    }
    
    @objc private func didTapWriteToUsButton() {
        animateDisappearing { [weak self] in
            self?.shouldShowMailController?()
        }
        Amplitude.instance().logEvent("reviewScreenOpen", withEventProperties: ["result": "dislike"])
    }
    
    private func setupSubviews() {
        view.addSubview(dimmingView)
        view.addSubview(container)
        container.addSubviews(
            titleLabel, logoImage, fruitsImage, lowerTitleLabel, writeReviewButton, writeUsMail, pullToCloseImage
        )
        
        dimmingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(506)
            make.top.equalTo(view.snp.bottom)
        }
        
        pullToCloseImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(13)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(80)
            make.top.equalToSuperview().offset(44)
        }
        
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(67)
        }
        
        fruitsImage.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(logoImage)
        }
        
        fruitsImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        lowerTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(80)
            make.top.equalTo(logoImage.snp.bottom).offset(34)
        }
        
        writeReviewButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(60)
            make.top.equalTo(lowerTitleLabel.snp.bottom).offset(16)
        }
        
        writeUsMail.snp.makeConstraints { make in
            make.leading.trailing.height.equalTo(writeReviewButton)
            make.top.equalTo(writeReviewButton.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(42)
        }
    }
    
    func animateAppearing() {
        container.snp.remakeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(506)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimmingView.alpha = 1
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(
                withDuration: 0.8,
                delay: 0,
                usingSpringWithDamping: 0.4,
                initialSpringVelocity: 0.1,
                options: [.curveEaseOut]
            ) {
                self.fruitsImage.transform = .identity
            }
        }
    }
    
    func animateDisappearing(completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.1,
            options: [.curveEaseOut]
        ) {
            self.fruitsImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.container.snp.remakeConstraints { make in
                    make.leading.trailing.equalToSuperview()
//                    make.height.equalTo(506)
                    make.top.equalTo(self.view.snp.bottom)
                }
                self.dimmingView.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { [weak self] _ in
                self?.dismiss(animated: true) {
                    completion?()
                }
            }
        }
    }
    
    @objc private func didPulledContainer(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: container).y
        switch sender.state {
        case .changed:
            guard translation > 0 else { return }
            container.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview()
//                make.height.equalTo(428)
                make.bottom.equalToSuperview().offset(translation)
            }
        case .ended:
            if translation < 214 {
                container.snp.remakeConstraints { make in
                    make.leading.trailing.equalToSuperview()
//                    make.height.equalTo(506)
                    make.bottom.equalToSuperview()
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            } else {
                animateDisappearing(completion: nil)
            }
        default:
            return
        }
    }
}

extension AskingOpinionViewController {
    enum Constants {
        static let shadows: [Shadow] = [
            .init(
                color: UIColor(hex: "000000").withAlphaComponent(0.0432),
                opacity: 0.0432,
                offset: CGSize(width: 0, height: -1),
                radius: 2.29,
                spread: 0
            ),
            .init(
                color: UIColor(hex: "000000").withAlphaComponent(0.0529),
                opacity: 0.0529,
                offset: CGSize(width: 0, height: -13),
                radius: 6.57,
                spread: 0
            ),
            .init(
                color: UIColor(hex: "000000").withAlphaComponent(0.15),
                opacity: 0.15,
                offset: CGSize(width: 0, height: -12),
                radius: 22,
                spread: 0
            )
        ]
    }
}

extension AskingOpinionViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
