//
//  LandingChartCell.swift
//  CalorieTracker
//
//  Created by Vladimir Banushkin on 20.04.2023.
//

import UIKit

final class LandingChartCell: UICollectionViewCell {
    static let identifier = String(describing: LandingChartCell.self)
    let shadowView: ViewWithShadow = {
        let view = ViewWithShadow(Constants.shadows)
        view.layer.cornerRadius = 12
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let chartImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage?) {
        chartImage.image = image
    }
    
    private func setupSubviews() {
        backgroundColor = .clear
        contentView.addSubview(shadowView)
        shadowView.addSubview(chartImage)
        shadowView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.verticalEdges.equalToSuperview()
        }
        
        chartImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension LandingChartCell {
    enum Constants {
        static let shadows: [Shadow] = [
            .init(
                color: .black,
                opacity: 0.03,
                offset: CGSize(width: 0, height: 1),
                radius: 16,
                spread: nil
            ),
            .init(
                color: .black,
                opacity: 0.03,
                offset: CGSize(width: 0, height: 6),
                radius: 8,
                spread: nil
            )
        ]
    }
}
