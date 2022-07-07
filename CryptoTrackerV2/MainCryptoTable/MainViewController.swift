//
//  MainViewController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 08.06.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let tableViewController: UITableViewController = {
        let tableViewController = UITableViewController()
        tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableViewController
    }()
    
    private var tableView: UITableView!
    
    private let refrashControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .systemPink
        return refreshControl
    }()
    
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private let detailUIView: DetailCoinView = {
        let detailCoinView = DetailCoinView()
        detailCoinView.backgroundColor = .white
        detailCoinView.layer.cornerRadius = 10
        detailCoinView.clipsToBounds = true
        //detailCoinView.translatesAutoresizingMaskIntoConstraints = false
        return detailCoinView
    }()
    
    
    var viewModel: MainViewControllerViewModelProtocol! {
        didSet {
            requestUpdateForTable()
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        tableView = tableViewController.tableView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestUpdateForTable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //setupConstraints()
    }
    
    private func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: searchController.searchBar.accessibilityFrame.minX,
                                 y: searchController.searchBar.frame.height,
                                 width: view.frame.width, height: view.frame.height)
        view.backgroundColor = .white
        
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.refreshControl = refrashControl
        refrashControl.addTarget(self, action: #selector(updateDataByRefreshControl), for: .valueChanged)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        //navigationItem.hidesSearchBarWhenScrolling = false
        
        viewModel.viewModelDidChange = { [unowned self] in
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchController.searchBar.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            //tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func requestUpdateForTable() {
        viewModel.featchData { [unowned self] in
            tableView.reloadData()
        }
    }
    
    // MARK: - Func for uplade tableView from refrashControl Not worked !!!
    @objc func updateDataByRefreshControl() {
        viewModel.updateCoinData { [unowned self] in
            tableView.reloadData()
        }
        refrashControl.endRefreshing()
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
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
        
        
        let detaitViewModel = viewModel.detailViewModel(at: indexPath)
        let indent = 0.8
        // view.frame.maxX * (1 - indent) / 2
        detailUIView.frame = CGRect(x: view.frame.maxX * (1 - indent) / 2,
                                    y: view.frame.maxY * (1 - indent) / 2,
                                    width: view.frame.width * indent, height: view.frame.height * 0.7)
        detailUIView.viewModel = detaitViewModel
        
        //let uiimage = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        //uiimage.image = UIImage(systemName: "star")
        view.addSubview(detailUIView)
        
//        NSLayoutConstraint.activate([
//            detailUIView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            detailUIView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            detailUIView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            detailUIView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
        
        
        //navigationController?.view.addSubview(detailUIView)
        
        //navigationController?.pushViewController(detailUIView, animated: true)
    }
}


// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterCoinsForSearchText(searchText: searchText)
    }
}
