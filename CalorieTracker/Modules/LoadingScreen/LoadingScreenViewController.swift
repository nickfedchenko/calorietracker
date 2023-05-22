//
//  LoadingScreenViewController.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 19.05.2023.
//  Copyright © 2023 FedmanCassad. All rights reserved.
//

import Lottie
import UIKit

protocol LoadingScreenViewControllerInterface: AnyObject {
    func updateLoadingStatus(by event: LoadingEvents)
}

class LoadingScreenViewController: UIViewController {
    var presenter: LoadingScreenPresenterInterface?
    
    let animatedLogo: LottieAnimationView = {
        let view = LottieAnimationView(filePath: R.file.kcalcLoaderJson()?.relativePath ?? "")
        view.animationSpeed = 1.5
        return view
    }()
    
    private let loadingField: UILabel = {
        let label = UILabel()
        label.font = R.font.jetBrainsMonoRegular(size: 9)
        label.textColor = .gray
        label.textAlignment = .center
        label.text = "Loading..."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupAppearance()
        setupLayout()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startLoadingAnimation()
    }
    
    private func setupSubviews() {
        view.addSubviews(animatedLogo, loadingField)
    }
    
    private func setupAppearance() {
        view.backgroundColor = .white
    }
    
    private func startLoadingAnimation() {
        animatedLogo.play(toProgress: 1, loopMode: .loop)
    }
    
    private func setupLayout() {
        animatedLogo.snp.makeConstraints { make in
            make.height.width.equalTo(128)
            make.center.equalToSuperview()
        }
        
        loadingField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }
    }
}

extension LoadingScreenViewController: LoadingScreenViewControllerInterface {
    func updateLoadingStatus(by event: LoadingEvents) {
        switch event {
        case .finished:
            DispatchQueue.main.async { [weak self] in
                self?.animateFinish()
                self?.loadingField.text = event.description
            }
        case .error:
            DispatchQueue.main.async { [weak self] in
                self?.showError()
            }
        default:
            DispatchQueue.main.async { [weak self] in
                self?.loadingField.text = event.description
            }
        }
    }
    
    private func showError() {
        let alertController = UIAlertController(
            title: "Oops",
            message: "An error occurred, please check your internet connection",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            self?.presenter?.viewDidLoad()
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func animateFinish() {
        animatedLogo.pause()
        animatedLogo.play(fromProgress: 0, toProgress: 1, loopMode: .autoReverse)
        UIView.animate(withDuration: 1) {
            let scale = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.animatedLogo.transform = scale
            self.loadingField.alpha = 0
        } completion: { [weak self] isFinished in
            if isFinished {
                self?.presenter?.notifyNeedMainScreen()
            }
        }
    }
}
