//
//  MainViewController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 08.06.2022.
//

import UIKit

class MainViewController: UITableViewController {

    private let refrashControl: UIRefreshControl = {
        let refrashControl = UIRefreshControl()
        refrashControl.tintColor = .systemPink
        refrashControl.addTarget(self, action: #selector(updateDataByRefrashControl), for: .valueChanged)
        return refrashControl
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    
    var viewModel: MainViewControllerViewModelProtocol! {
        didSet {
            requestUpdateForTable()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestUpdateForTable()
    }
    
    
    private func setupUI() {
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.refreshControl = refrashControl
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        viewModel.viewModelDidChange = { [unowned self] in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    private func requestUpdateForTable() {
        viewModel.featchData { [unowned self] in
            tableView.reloadData()
        }
    }
    
    // MARK: - Func for uplade tableView from refrashControl Not worked !!!
    @objc func updateDataByRefrashControl() {
        requestUpdateForTable()
        refrashControl.endRefreshing()
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CryptoTableViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detaitViewModel = viewModel.detailViewModel(at: indexPath)
        let detailViewController = DetailCoinViewController()
        detailViewController.viewModel = detaitViewModel
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}


// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterCoinsForSearchText(searchText: searchText)
    }
}
