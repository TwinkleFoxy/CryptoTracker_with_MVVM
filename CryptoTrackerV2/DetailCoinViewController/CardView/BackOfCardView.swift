//
//  BackOfCard.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 09.07.2022.
//

import UIKit

class BackOfCardView: UIView {
    
    private let imageCoinView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.35
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coin Name: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Coin Price: "
        label.font = .systemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let marketStatusTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Status:"
        label.font = .systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.text = "Market Cap:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let curculatinSupply: UILabel = {
        let label = UILabel()
        label.text = "Curculatin Supply:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let maxSupply: UILabel = {
        let label = UILabel()
        label.text = "Max Supply:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let height24h: UILabel = {
        let label = UILabel()
        label.text = "Height24h:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let low24h: UILabel = {
        let label = UILabel()
        label.text = "Low24h:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceChange24h: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //MARK: - Stacks View
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
        stackView.spacing = 20
        stackView.contentMode = .scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let stackViewTop: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.contentMode = .scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let stackViewBottom: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.contentMode = .scaleAspectFill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let stackViewBottomNested: UIStackView  = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.contentMode = .scaleToFill
        stackView.translatesAutoresizingMaskIntoConstraints = true
        return stackView
    }()
    
    
    //MARK: - DetailCoinView
    unowned var viewModel: DetailCoinViewViewModelProtocol!
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setupUI()
        setupSubView()
        setupFrame()
        setupConstraints()
        // Drawing code
    }
    
    
    //MARK: - SetupUI
    private func setupUI(){
        imageCoinView.image = UIImage(data: viewModel.imageData)
        coinNameLabel.text = viewModel.coinName
        coinPriceLabel.text = viewModel.coinPrice
        marketCapLabel.text = viewModel.marketCap
        curculatinSupply.text = viewModel.curculatinSupply
        maxSupply.text = viewModel.maxSupply
        height24h.text = viewModel.height24h
        low24h.text = viewModel.low24h
        priceChange24h.text = viewModel.priceChange24h
    }
    
    //MARK: - Setup Frame
    func setupFrame() {
        let imageSize = 0.8
        imageCoinView.frame = CGRect(x: (frame.maxX * (1 - imageSize)) / 2,
                                     y: 0,
                                     width: frame.width * imageSize,
                                     height: frame.height * imageSize)
    }
    
    //MARK: - Setup SubView
    private func setupSubView() {
        addSubview(imageCoinView)
        
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(stackViewTop)
        mainStackView.addArrangedSubview(stackViewBottom)
        
        stackViewTop.addArrangedSubview(coinNameLabel)
        stackViewTop.addArrangedSubview(coinPriceLabel)
        
        stackViewBottom.addArrangedSubview(marketStatusTextLabel)
        stackViewBottom.addArrangedSubview(stackViewBottomNested)
        
        stackViewBottomNested.addArrangedSubview(marketCapLabel)
        stackViewBottomNested.addArrangedSubview(curculatinSupply)
        stackViewBottomNested.addArrangedSubview(maxSupply)
        stackViewBottomNested.addArrangedSubview(height24h)
        stackViewBottomNested.addArrangedSubview(low24h)
        stackViewBottomNested.addArrangedSubview(priceChange24h)
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageCoinView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            imageCoinView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageCoinView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageCoinView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
    }
}
