//
//  DetailCoinView.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 05.07.2022.
//

import UIKit

class DetailCoinView: UIView {
    
    private let imageCoinView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0.35
        imageView.contentMode = .scaleAspectFit
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
    
    private let favoritButton: UIButton = {
        let favoritButton = UIButton()
        favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoritButton.translatesAutoresizingMaskIntoConstraints = false
        return favoritButton
    }()
    
    private let clouseButton: UIButton = {
        let clouseButton = UIButton(type: .close)
        clouseButton.addTarget(self, action: #selector(clouseView), for: .touchDown)
        clouseButton.translatesAutoresizingMaskIntoConstraints = false
        return clouseButton
    }()
    
    
    
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
    
    private let barButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "star")
        return barButtonItem
    }()
    
    
    //MARK: - DetailCoinView
    var viewModel: DetailCoinViewControllerViewModelProtocol!
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setupUI()
        setupSubView()
        setFavoritStatus(isFavorit: viewModel.isFavorit)
        // Drawing code
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        setupConstraints()
    }
    
    //MARK: - SetupUI
    private func setupUI(){
        
        //navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.action = #selector(favoritButtonPressed)
        barButtonItem.target = self
        clouseButton.addTarget(self, action: #selector(clouseView), for: .touchDown)
        
        let imageSize = 0.8
        imageCoinView.image = UIImage(data: viewModel.imageData)
        imageCoinView.frame = CGRect(x: (frame.maxX * (1 - imageSize)) / 2,
                                     y: 0,
                                     width: frame.width * imageSize,
                                     height: frame.height * imageSize)
        clouseButton.frame = CGRect(x: (frame.width / 2) - 10, y: frame.height, width: 40, height: 40)
        
        coinNameLabel.text = viewModel.coinName
        setFavoritStatus(isFavorit: viewModel.isFavorit)
        viewModel.viewModelDidChange = { [unowned self] viewModel in
            self.setFavoritStatus(isFavorit: viewModel.isFavorit)
        }
        coinPriceLabel.text = viewModel.coinPrice
        marketCapLabel.text = viewModel.marketCap
        curculatinSupply.text = viewModel.curculatinSupply
        maxSupply.text = viewModel.maxSupply
        height24h.text = viewModel.height24h
        low24h.text = viewModel.low24h
        priceChange24h.text = viewModel.priceChange24h
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
        //stackViewBottomNested.addArrangedSubview(curculatinSupply)
        stackViewBottomNested.addArrangedSubview(maxSupply)
        stackViewBottomNested.addArrangedSubview(height24h)
        stackViewBottomNested.addArrangedSubview(low24h)
        stackViewBottomNested.addArrangedSubview(priceChange24h)
        
        addSubview(clouseButton)
        
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            imageCoinView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            imageCoinView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
//            imageCoinView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
//            imageCoinView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
//
//        ])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            //mainStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            clouseButton.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
            clouseButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            clouseButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func favoritButtonPressed() {
        viewModel.favoritToggle()
    }
    
    @objc private func clouseView() {
        removeFromSuperview()
    }
    
    private func setFavoritStatus(isFavorit: Bool) {
        barButtonItem.image = viewModel.isFavorit ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
}
