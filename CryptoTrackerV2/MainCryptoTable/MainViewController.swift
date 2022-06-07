//
//  MainViewController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 13.05.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let refrashControl: UIRefreshControl = {
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
            viewModel.featchData {
                self.tableView.reloadData()
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewControllerViewModel()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        tableView.refreshControl = refrashControl
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        viewModel.viewModelDidChange = { [unowned self] _ in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    // MARK: - Func for uplade tableView from refrashControl Not worked !!!
    @objc func updateDataByRefrashControl() {
        viewModel.featchData {
            self.tableView.reloadData()
        }
        refrashControl.endRefreshing()
    }
    
    
//     MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! DetailCoinViewController
        let viewModel = sender as? DetailCoinViewControllerViewModelProtocol
        dvc.viewModel = viewModel
    }
}



extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CryptoTableViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = viewModel.detailViewModel(at: indexPath)
        performSegue(withIdentifier: "detailViewControllerSegue", sender: coin)
    }
    
}



extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterCoinsForSearchText(searchText: searchText)
    }
}
