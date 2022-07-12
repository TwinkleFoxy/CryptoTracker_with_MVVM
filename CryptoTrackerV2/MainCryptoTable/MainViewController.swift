//
//  MainViewController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 08.06.2022.
//

import UIKit

protocol BackGroundBlurEffectProtocol: AnyObject {
    func removeBackGroundBlurEffectAndUpdateDataIfNeed()
}

class MainViewController: UIViewController {
    
    private let tableViewController: UITableViewController = {
        let tableViewController = UITableViewController()
        tableViewController.tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableViewController
    }()
    
    private var tableView: UITableView!
    
    private let visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .systemMaterial)
        return visualEffectView
    }()
    
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
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestUpdateForTable()
    }
    
    //MARK: - ViewWillLayoutSubviews
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        view.backgroundColor = .white
        
        visualEffectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        tableView.refreshControl = refrashControl
        refrashControl.addTarget(self, action: #selector(updateDataByRefreshControl), for: .valueChanged)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Setup TableView
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: searchController.searchBar.accessibilityFrame.minX,
                                 y: searchController.searchBar.frame.height,
                                 width: view.frame.width, height: view.frame.height)
        tableView.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    private func requestUpdateForTable() {
        viewModel.featchData { [unowned self] in
            tableView.reloadData()
        }
    }
    
    // MARK: - Func for uplade tableView from refrashControl
    @objc func updateDataByRefreshControl() {
        viewModel.updateCoinData { [unowned self] in
            tableView.reloadData()
        }
        refrashControl.endRefreshing()
    }
    
    private func createDetailCoinView(viewModel: DetailCoinViewViewModelProtocol) -> DetailCoinView {
        let indentX = 0.9
        let indentY = 0.7
        let detailCoinView = DetailCoinView()
        detailCoinView.previousTableViewController = self
        detailCoinView.backgroundColor = .white
        detailCoinView.layer.cornerRadius = 10
        detailCoinView.clipsToBounds = true
        detailCoinView.frame = CGRect(x: view.frame.maxX * (1 - indentX) / 2,
                                      y: view.frame.maxY * (1 - indentY) / 2,
                                      width: view.frame.width * indentX, height: view.frame.height * indentY)
        detailCoinView.viewModel = viewModel
        detailCoinView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        return detailCoinView
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
        let viewModel = viewModel.detailViewModel(at: indexPath)
        
        let detailCoinView = createDetailCoinView(viewModel: viewModel)
        
        addBackGroundBlurEffect()
        view.addSubview(detailCoinView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            detailCoinView.transform = .identity
        }
    }
}


//MARK: - BackGroundBlurEffectProtocol
extension MainViewController: BackGroundBlurEffectProtocol {
    func addBackGroundBlurEffect() {
        searchController.searchBar.isHidden = true
        navigationItem.hidesSearchBarWhenScrolling = true
        view.addSubview(visualEffectView)
    }
    
    func removeBackGroundBlurEffectAndUpdateDataIfNeed() {
        requestUpdateForTable()
        let searchText = CacheData.shared.getSearchText()
        viewModel.filterCoinsForSearchText(searchText: searchText)
        navigationItem.hidesSearchBarWhenScrolling = false
        visualEffectView.removeFromSuperview()
        searchController.searchBar.isHidden = false
    }
}


// MARK: - UISearchResultsUpdating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        CacheData.shared.setSearchText(searchText: searchText)
        viewModel.filterCoinsForSearchText(searchText: searchText)
    }
}
