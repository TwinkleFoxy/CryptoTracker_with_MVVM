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
    
    lazy private var collectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        return collectionView
    }()
    
    private let visualEffectView: UIVisualEffectView = {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.effect = UIBlurEffect(style: .systemMaterialDark)
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
    
    private let minimumLineSpacing: CGFloat = 10
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
        
        collectionView.refreshControl = refrashControl
        refrashControl.addTarget(self, action: #selector(updateDataByRefreshControl), for: .valueChanged)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        viewModel.viewModelDidChange = { [unowned self] in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    //MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchController.searchBar.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Setup CollectionView
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: minimumLineSpacing, bottom: 0, right: minimumLineSpacing)
        collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionCell")
    }
    
    private func requestUpdateForTable() {
        viewModel.featchData { [unowned self] internetStatus in
            if internetStatus {
                collectionView.reloadData()
                refrashControl.endRefreshing()
            } else {
                present(AlertController.showAlertController(title: "Internet connection Error", message: "Check internet connection"), animated: true) {
                    self.refrashControl.endRefreshing()
                }
            }
        }
        refrashControl.endRefreshing()
    }
    
    // MARK: - Func for uplade tableView from refrashControl
    @objc func updateDataByRefreshControl() {
        viewModel.updateCoinData { [unowned self] internetStatus in
            if internetStatus {
                collectionView.reloadData()
                refrashControl.endRefreshing()
            } else {
                present(AlertController.showAlertController(title: "Internet connection Error", message: "Check internet connection"), animated: true) {
                    self.refrashControl.endRefreshing()
                }
            }
        }
    }
    
    private func createDetailCoinView(viewModel: DetailCoinViewViewModelProtocol) -> DetailCoinView {
        let indentX = 0.9
        let indentY = 0.70
        let detailViewX = view.frame.maxX * (1 - indentX) / 2
        let detailViewY = view.frame.maxY * (1 - indentY) / 2
        let detailViewWidth = view.frame.width * indentX
        let detailViewHeight = detailViewWidth * 1.4
        let detailCoinView = DetailCoinView()
        detailCoinView.previousTableViewController = self
        detailCoinView.backgroundColor = .white
        detailCoinView.layer.cornerRadius = 10
        detailCoinView.clipsToBounds = true
        detailCoinView.frame = CGRect(x: detailViewX,
                                      y: detailViewY,
                                      width: detailViewWidth, height: detailViewHeight)
        detailCoinView.viewModel = viewModel
        detailCoinView.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        return detailCoinView
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionCell", for: indexPath) as? CryptoCollectionViewCell else { return UICollectionViewCell() }
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let viewModel = viewModel.detailViewModel(at: indexPath)
        let detailCoinView = createDetailCoinView(viewModel: viewModel)
        
        addBackGroundBlurEffect()
        view.addSubview(detailCoinView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            detailCoinView.transform = .identity
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let leftIndent = minimumLineSpacing
        let rightIndent = minimumLineSpacing
        let lineIndent = minimumLineSpacing
        let numberCellInLine: CGFloat = 2
        
        let widthCell = (view.safeAreaLayoutGuide.layoutFrame.width - leftIndent - rightIndent - (lineIndent * (numberCellInLine - 1))) / numberCellInLine
                         let heightCell = widthCell * 1.4
        return CGSize(width: widthCell, height: heightCell)
    }
}


//MARK: - BackGroundBlurEffectProtocol
extension MainViewController: BackGroundBlurEffectProtocol {
    func addBackGroundBlurEffect() {
        searchController.searchBar.isHidden = true
        navigationItem.hidesSearchBarWhenScrolling = true
        tabBarController?.tabBar.isHidden = true
        view.addSubview(visualEffectView)
    }
    
    func removeBackGroundBlurEffectAndUpdateDataIfNeed() {
        requestUpdateForTable()
        let searchText = CacheData.shared.getSearchText()
        viewModel.filterCoinsForSearchText(searchText: searchText)
        navigationItem.hidesSearchBarWhenScrolling = false
        visualEffectView.removeFromSuperview()
        searchController.searchBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
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
