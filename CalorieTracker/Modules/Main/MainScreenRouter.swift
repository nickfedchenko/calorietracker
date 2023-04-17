//
//  MainScreenRouter.swift
//  CIViperGenerator
//
//  Created by FedmanCassad on 18.07.2022.
//  Copyright © 2022 FedmanCassad. All rights reserved.
//

import ApphudSDK
import MessageUI
import UIKit

protocol MainScreenRouterInterface: AnyObject {
    func openAddFoodVC()
    func openWidget(_ type: WidgetContainerViewController.WidgetType, anchorView: UIView?)
    func openSettingsVC()
    func openOnboarding()
    func openCreateNotesVC()
    func openAllNotesVC()
    func openBarcodeScannerVC()
    func openOpenMainWidget(_ date: Date)
}

class MainScreenRouter: NSObject {
    
    weak var presenter: MainScreenPresenterInterface?
    weak var viewController: UIViewController?
    
    static func setupModule() -> MainScreenViewController {
        let vc = MainScreenViewController()
        let interactor = MainScreenInteractor()
        let router = MainScreenRouter()
        let presenter = MainScreenPresenter(interactor: interactor, router: router, view: vc)
        
        vc.presenter = presenter
        router.presenter = presenter
        router.viewController = vc
        interactor.presenter = presenter
        return vc
    }
}

extension MainScreenRouter: MainScreenRouterInterface {
    func openSettingsVC() {
        let vc = SettingsRouter.setupModule()
        viewController?.present(
            TopDownNavigationController(rootViewController: vc),
            animated: true
        )
    }
    
    func openAddFoodVC() {
        LoggingService.postEvent(event: .diaryaddfood)
        let handler: (() -> Void) = { [weak self] in
            if RateRequestManager.shouldAskOpinion {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) { [weak self] in
                    self?.showRateUsView()
                }
            }
        }
        let vc = AddFoodRouter.setupModule(
            addFoodYCoordinate: UDM.mainScreenAddButtonOriginY,
            needShowReviewController: handler,
            navigationType: .modal
        )
        viewController?.navigationController?.delegate = self
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openWidget(_ type: WidgetContainerViewController.WidgetType, anchorView: UIView? = nil) {
        switch type {
        case.steps:
//            #if AppStore
            if !UDM.isAuthorisedHealthKit {
                HealthKitAccessManager.shared.askPermission { result in
                    switch result {
                    case .success(let success):
                        UDM.isAuthorisedHealthKit = success
                        HealthKitDataManager.shared.getSteps { steps in
                            DSF.shared.saveSteps(steps)
                        }

                        HealthKitDataManager.shared.getWorkouts { exercises  in
                            DSF.shared.saveExercises(exercises)
                        }

                    case .failure(let failure):
                        print(failure)
                    }
                }
                return
            }
//            #endif
            fallthrough
        case .exercises:
            if !UDM.isAuthorisedHealthKit {
                HealthKitAccessManager.shared.askPermission { result in
                    switch result {
                    case .success(let success):
                        UDM.isAuthorisedHealthKit = success
                        HealthKitDataManager.shared.getSteps { steps in
                            DSF.shared.saveSteps(steps)
                        }
                        
                        HealthKitDataManager.shared.getWorkouts { exercises  in
                            DSF.shared.saveExercises(exercises)
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
                return
            }
            fallthrough
        default:
            print()
        }
    
        let vc = WidgetContainerRouter.setupModule(type, anchorView: anchorView)
        vc.output = self
        
        viewController?.present(vc, animated: true)
    }
    
    func openOnboarding() {
        let vc = WelcomeRouter.setupModule()
        viewController?.present(
            UINavigationController(rootViewController: vc),
            animated: false
        )
    }
    
    func openCreateNotesVC() {
        let vc = NotesCreateViewController()
        vc.handlerAllNotes = { [weak self] in
            self?.openAllNotesVC()
        }
        vc.needUpdate = { [weak self] in
            self?.presenter?.updateNoteWidget()
        }
        viewController?.present(vc, animated: true)
    }
    
    func openAllNotesVC() {
        let vc = NotesRouter.setupModule()
        
        viewController?.present(
            TopDownNavigationController(rootViewController: vc),
            animated: true
        )
    }
    
    func openOpenMainWidget(_ date: Date) {
        let vc = OpenMainWidgetRouter.setupModule(date) { [weak self] in
            self?.presenter?.updateActivityWidget()
        }
        viewController?.present(
            OpenMainWidgetNavigationController(rootViewController: vc),
            animated: true
        )
    }
    
    private func showRateUsView() {
        let vc = AskingOpinionViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.shouldShowMailController = { [weak self] in
            self?.showMailController()
        }
        vc.shouldOpenWriteReviewPage = { [weak self] in
            self?.openReviewPage()
            UDM.didTapToWriteReview = true
        }
        viewController?.navigationController?.present(vc, animated: true)
    }
    
    private func showMailController() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["po.fedchenko.top@gmail.com"])
            mail.setSubject("Here is my feedback for version \(Bundle.main.appVersionLong)(\(Bundle.main.appBuild))")
            mail.setMessageBody(
                "<p>Version \(Bundle.main.appVersionLong)(\(Bundle.main.appBuild)).</p>",
                isHTML: true
            )
            viewController?.navigationController?.present(mail, animated: true)
        } else {
            print("Cant send an e-mail")
        }
    }
    
    private func openReviewPage() {
        guard
            let url = URL(string: "itms-apps://itunes.apple.com/app/id1667349931?action=write-review"),
            UIApplication.shared.canOpenURL(url)
        else {
            return
        }
        UIApplication.shared.open(url)
    }
}

extension MainScreenRouter: WidgetContainerOutput {
    func needUpdateWidget(_ type: WidgetContainerViewController.WidgetType) {
        switch type {
        case .water:
            self.presenter?.updateWaterWidgetModel()
        case .steps:
            self.presenter?.updateStepsWidget()
        case .calendar:
            self.presenter?.updateCalendarWidget(nil)
        case .weight:
            self.presenter?.updateWeightWidget()
        case .exercises:
            self.presenter?.updateExersiceWidget()
        default:
            return
        }
    }
    
    func needUpdateCalendarWidget(_ date: Date?) {
        guard let date = date else { return }
        self.presenter?.setPointDate(date)
        self.presenter?.updateCalendarWidget(date)
    }
    
    func openBarcodeScannerVC() {
        LoggingService.postEvent(event: .diaryscanfood)
        guard Apphud.hasActiveSubscription() else {
            let paywall = PaywallRouter.setupModule()
            paywall.modalPresentationStyle = .fullScreen
            viewController?.navigationController?.present(paywall, animated: true)
            return
        }
        
        let vc = ScannerRouter.setupModule { [weak self] barcode in
            self?.openAddFoodVCandPerformSearch(with: barcode)
        }
        viewController?.present(TopDownNavigationController(rootViewController: vc), animated: true)
    }
    
    private func openAddFoodVCandPerformSearch(with barcode: String) {
        let vc = AddFoodRouter.setupModule(
            shouldInitiallyPerformSearchWith: barcode,
            addFoodYCoordinate: UDM.mainScreenAddButtonOriginY,
            navigationType: .modal
        )
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MainScreenRouter: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            if fromVC is CTTabBarController {
                return AddFoodControllerPushAnimationController()
            } else {
                return nil
            }
        } else {
            if toVC is CTTabBarController {
                return AddFoodControllerPopAnimationController()
            } else {
                return nil
            }
        }
    }
}

extension MainScreenRouter: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
