//
//  Face.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 09.07.2022.
//

import UIKit

class FaceCardView: UIView {
    
    private let imageCoinView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.35
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - DetailCoinView
    unowned var viewModel: DetailCoinViewViewModelProtocol!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setupUI()
        setupSubView()
        setupConstraints()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        imageCoinView.image = UIImage(data: viewModel.imageData)
    }
    
    //MARK: - Setup SubView
    private func setupSubView() {
        addSubview(imageCoinView)
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageCoinView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageCoinView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageCoinView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            imageCoinView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    

}
