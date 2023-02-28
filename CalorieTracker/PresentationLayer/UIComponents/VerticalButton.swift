//
//  VerticalButton.swift
//  CalorieTracker
//
//  Created by Vadim Aleshin on 10.11.2022.
//

import UIKit

final class VerticalButton: UIControl {
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    private var imageAndStates: [UIControl.State: UIImage?] = [:]
    private var titleAndStates: [UIControl.State: String?] = [:]
    private var titleColorAndStates: [UIControl.State: UIColor?] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ image: UIImage?, _ state: UIControl.State) {
        imageAndStates[state] = image
        imageView.image = state == .normal ? image : nil
    }
    
    func setTitle(_ title: String?, _ state: UIControl.State) {
        titleAndStates[state] = title
        titleLabel.text = state == .normal ? title : nil
    }
    
    func setTitleColor(_ color: UIColor?, _ state: UIControl.State) {
        titleColorAndStates[state] = color
        titleLabel.textColor = state == .normal ? color : nil
    }
    
    private func addSubviews() {
        addSubviews(imageView, titleLabel)
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(13)
            make.top.equalTo(imageView.snp.bottom).offset(1)
            make.bottom.equalToSuperview().inset(6)
        }
    }
}

extension VerticalButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        imageView.image = imageAndStates[.highlighted] ?? imageAndStates.first?.value
        titleLabel.text = titleAndStates[.highlighted] ?? titleAndStates.first?.value
        titleLabel.textColor = titleColorAndStates[.highlighted]
            ?? titleColorAndStates.first?.value
            ?? .black
        
        if imageAndStates[.highlighted] == nil
            && titleAndStates[.highlighted] == nil
            && titleColorAndStates[.highlighted] == nil {
            UIView.animate(withDuration: 0.1) {
                self.layer.opacity = 0.8
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        imageView.image = imageAndStates[.normal] ?? imageAndStates.first?.value
        titleLabel.text = titleAndStates[.normal] ?? titleAndStates.first?.value
        titleLabel.textColor = titleColorAndStates[.normal]
            ?? titleColorAndStates.first?.value
            ?? .black
        
        self.layer.opacity = 1
    }
}

extension UIControl.State: Hashable {}
