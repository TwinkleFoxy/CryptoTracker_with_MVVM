//
//  FavoritCoinsViewController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 07.06.2022.
//

import UIKit

class FavoritCoinsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refrashControl: UIRefreshControl = {
        let refrashControl = UIRefreshControl()
        refrashControl.tintColor = .systemPink
        refrashControl.addTarget(self, action: #selector(updateDataByRefrashControl), for: .valueChanged)
        return refrashControl
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    var viewModel: FavoritCoinsViewControllerViewModelProtocol! {
        didSet {
            requestUpdateForTable()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavoritCoinsViewControllerViewModel()
        
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestUpdateForTable()
    }
    
    private func setupUI() {
        tableView.refreshControl = refrashControl
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        viewModel.viewModelDidChange = { [unowned self] in
            tableView.reloadData()
        }
    }
    
    func requestUpdateForTable() {
        viewModel.featchData { [unowned self] in
            tableView.reloadData()
        }
    }
    
    @objc func updateDataByRefrashControl() {
        requestUpdateForTable()
        refrashControl.endRefreshing()
    }
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         guard let dvc = segue.destination as? DetailCoinViewController else { return }
         let viewModel = sender as? DetailCoinViewControllerViewModelProtocol
         dvc.viewModel = viewModel
     }
     
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FavoritCoinsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CryptoTableViewCell else { return UITableViewCell() }
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewModel = viewModel.detailViewModel(at: indexPath)
        performSegue(withIdentifier: "detailFavoritViewControllerSegue", sender: detailViewModel)
    }
}

// MARK: - UISearchResultsUpdating
extension FavoritCoinsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.searchTextField.text else { return }
        viewModel.filterCoinForSearchText(searchText: searchText)
    }
}

