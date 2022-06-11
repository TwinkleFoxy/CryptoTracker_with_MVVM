//
//  DetailCoinViewController1.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 08.06.2022.
//

import UIKit

class DetailCoinViewController1: UIViewController {
    
    private let coinNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coin Name: "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let coinPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Coin Price: "
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
        favoritButton.translatesAutoresizingMaskIntoConstraints = false
        favoritButton.setImage(UIImage(systemName: "star"), for: .normal)
        return favoritButton
    }()
    
    
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalCentering
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
    
    private let stackViewMidle: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.contentMode = .scaleAspectFit
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
    
    
    //MARK: - DetailCoinViewController
    var viewModel: DetailCoinViewControllerViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSubView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavoritStatus(isFavorit: viewModel.isFavorit)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setupConstraints()
    }
    
    //MARK: - SetupUI
    private func setupUI(){
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = barButtonItem
        barButtonItem.action = #selector(favoritButtonPressed)
        barButtonItem.target = self
        
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
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(stackViewTop)
        mainStackView.addArrangedSubview(stackViewMidle)
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
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            stackViewMidle.topAnchor.constraint(equalTo: stackViewTop.bottomAnchor, constant: 20),
            stackViewMidle.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            stackViewMidle.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            stackViewMidle.bottomAnchor.constraint(equalTo: stackViewBottom.topAnchor, constant: -20)
        ])
        
    }
    
    
    @objc func favoritButtonPressed() {
        viewModel.favoritToggle()
    }
    
    private func setFavoritStatus(isFavorit: Bool) {
        barButtonItem.image = viewModel.isFavorit ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
