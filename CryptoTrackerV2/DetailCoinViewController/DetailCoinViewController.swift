//
//  DetailCoinViewController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 13.05.2022.
//

import UIKit

class DetailCoinViewController: UIViewController {

    
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var marketCapLabel: UILabel!
    @IBOutlet weak var curculatinSupply: UILabel!
    @IBOutlet weak var maxSupply: UILabel!
    @IBOutlet weak var height24h: UILabel!
    @IBOutlet weak var low24h: UILabel!
    @IBOutlet weak var priceChange24h: UILabel!
    @IBOutlet weak var favoritButton: UIBarButtonItem!
    
    
    var viewModel: DetailCoinViewControllerViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        coinNameLabel.text = viewModel.coinName
        setFavoritStatus()
        viewModel.viewModelDidChange = { [ unowned self] viewModel in
            self.setFavoritStatus()
        }
        coinPriceLabel.text = viewModel.coinPrice
        marketCapLabel.text = viewModel.marketCap
        curculatinSupply.text = viewModel.curculatinSupply
        maxSupply.text = viewModel.maxSupply
        height24h.text = viewModel.height24h
        low24h.text = viewModel.low24h
        priceChange24h.text = viewModel.priceChange24h
    }
    
    @IBAction func favoritButtonPressed(_ sender: UIBarButtonItem) {
        viewModel.favoritToggle()
    }
    
    func setFavoritStatus() {
        favoritButton.image = viewModel.isFavorit ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
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
