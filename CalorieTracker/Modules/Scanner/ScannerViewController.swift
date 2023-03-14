//
//  ScannerViewController.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 28.11.2022.
//

import AVFoundation
import UIKit

final class ScannerViewController: UIViewController {
    
    // MARK: - Public
    
    enum ScannerState {
        case barcodeRecognized
        case barcodeExists
        case `default`
    }
    
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var router: ScannerRouterInterface?
    var didRecognizedBarcode: ((String) -> Void)?
    
    var complition: ((String) -> Void)?

    // MARK: - Private
    
    private var captureSession = AVCaptureSession()
    
    private var scannerState: ScannerState = .default {
        didSet {
            didChangeState()
        }
    }
    
    private var barcode: String? {
        didSet {
            if oldValue != barcode {
                DispatchQueue.main.async {
                    self.didChangeBarcodeValue()
                }
            }
        }
    }
    
    private lazy var closeButton: UIButton = getCloseButton()
    private lazy var lightButton: UIButton = getLightButton()
    private lazy var editButton: UIButton = getEditButton()
    private lazy var overlayView: UIView = getOverlayView()
    private lazy var maskView: UIView = getMaskView()

    // MARK: - Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupCamera()
        setupView()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setMask(with: maskView.frame, in: overlayView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCamera()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        DispatchQueue.global(qos: .userInitiated).async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
            }
        }
    }
    
    // MARK: - Private Functions
    
    private func setupView() {
        view.backgroundColor = .white
        lightButton.layer.cornerCurve = .circular
        lightButton.layer.cornerRadius = 24
        editButton.layer.cornerCurve = .circular
        editButton.layer.cornerRadius = 24
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
            let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.beginConfiguration()
            if let currentInput = self.captureSession.inputs.first {
                self.captureSession.removeInput(currentInput)
            }
            
            if let currentOutput = self.captureSession.outputs.first {
                self.captureSession.removeOutput(currentOutput)
            }
            
            if self.captureSession.canAddInput(input) {
                self.captureSession.addInput(input)
            }

            let metadataOutput = AVCaptureMetadataOutput()

            if self.captureSession.canAddOutput(metadataOutput) {
                self.captureSession.addOutput(metadataOutput)

                metadataOutput.setMetadataObjectsDelegate(self, queue: .global(qos: .userInitiated))

                if Set([.qr, .ean13, .code128, .code39])
                    .isSubset(of: metadataOutput.availableMetadataObjectTypes) {
                    metadataOutput.metadataObjectTypes = [.qr, .ean13, .code128, .code39]
                }
            } else {
                print("Could not add metadata output")
            }
            self.captureSession.commitConfiguration()

            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.videoGravity = .resizeAspectFill
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
            }
            DispatchQueue.main.async {
                self.previewLayer.frame = self.view.bounds
                self.view.layer.insertSublayer(self.previewLayer, at: 0)
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubviews(
            overlayView,
            maskView,
            closeButton,
            lightButton,
            editButton
        )
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        maskView.aspectRatio()
        maskView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(35)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(64)
            make.bottom.equalToSuperview().offset(-24)
        }
        
        lightButton.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.top.equalTo(maskView.snp.bottom).offset(32)
            make.trailing.equalTo(maskView.snp.trailing).offset(-32)
        }
        
        editButton.snp.makeConstraints { make in
            make.height.width.equalTo(48)
            make.top.equalTo(maskView.snp.bottom).offset(32)
            make.leading.equalTo(maskView.snp.leading).offset(32)
        }
    }
    
    private func didChangeState() {
        switch scannerState {
        case .barcodeRecognized:
            Vibration.success.vibrate()
            didRecognizedBarcode?(barcode ?? "")
            maskView.layer.borderWidth = 2
            LoggingService.postEvent(event: .diarybarcoderead(succeeded: true))
        case .barcodeExists:
            guard let barcode = barcode else { return }
            Vibration.warning.vibrate()
            UIView.animate(withDuration: 0.7, delay: .zero) {
                self.maskView.layer.borderWidth = 2
            } completion: { [weak self] _ in
                self?.router?.barCodeSuccessfullyRecognized(barcode: barcode)
                LoggingService.postEvent(event: .diarybarcoderead(succeeded: true))
            }
        case .default:
            LoggingService.postEvent(event: .diarybarcoderead(succeeded: false))
            maskView.layer.borderWidth = 0
        }
    }
    
    private func didChangeBarcodeValue() {
        guard let barcode = barcode else { return }
        scannerState = .barcodeExists
//        guard let product = DSF.shared.searchProducts(barcode: barcode).first else {
//            self.scannerState = .barcodeRecognized
//            self.complition?(barcode)
//            return
//        }
        
    }
    
//    private func showAlert(_ product: Product) {
//        let alertVC = UIAlertController(
//            title: R.string.localizable.scanAlertTitle(),
//            message: R.string.localizable.scanAlertDescription(),
//            preferredStyle: .alert
//        )
//        
//        alertVC.addAction(UIAlertAction(
//            title: R.string.localizable.cancel(),
//            style: .cancel
//        ))
//        
//        alertVC.addAction(UIAlertAction(
//            title: R.string.localizable.viewing(),
//            style: .default,
//            handler: { [weak self] _ in
//                self?.router?.openProductViewController(product)
//            }
//        ))
//        
//        present(alertVC, animated: true)
//    }
    
    private func setMask(with hole: CGRect, in view: UIView) {
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRect(hole)

        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = CAShapeLayerFillRule.evenOdd

        view.layer.mask = mask
    }
    
    @objc private func didTapCloseButton() {
        Vibration.rigid.vibrate()
        router?.close()
    }
    
    @objc private func didTapLightButton() {
        Vibration.rigid.vibrate()
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        if device.isTorchActive {
            lightButton.setImage(R.image.foodViewing.lightOn(), for: .normal)
            device.flash(flag: false)
        } else {
            lightButton.setImage(R.image.foodViewing.lightOff(), for: .normal)
            device.flash(flag: true)
        }
    }
    
    @objc private func didTapEditButton() {
        Vibration.selection.vibrate()
    }
}

// MARK: - AVCaptureMetadataOutputObjects Delegate

extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        print("somethimg happened")
        for metadata in metadataObjects {
            if let readableObject = metadata as? AVMetadataMachineReadableCodeObject,
                let code = readableObject.stringValue {
                self.barcode = code
            } else {
                DispatchQueue.main.async {
                    self.scannerState = .default
                }
            }
        }
    }
}

// MARK: - Factory

extension ScannerViewController {
    private func getCloseButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.topChevron(), for: .normal)
        button.imageView?.tintColor = R.color.foodViewing.basicGrey()
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }
    
    private func getLightButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.lightOn(), for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.25)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(didTapLightButton), for: .touchUpInside)
        return button
    }
    
    private func getEditButton() -> UIButton {
        let button = UIButton()
        button.setImage(R.image.foodViewing.edit(), for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.25)
        button.imageView?.tintColor = .white
        button.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        return button
    }
    
    private func getOverlayView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.75)
        return view
    }
    
    private func getMaskView() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = R.color.foodViewing.greenPrimary()?.cgColor
        return view
    }
}
