//
//  MainTabBarController.swift
//  CryptoTrackerV2
//
//  Created by Алексей Однолько on 08.06.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        
        // Do any additional setup after loading the view.
    }
    
    private func setupTabBar() {
        var arrayOfControllers: [UIViewController] = []
        
        arrayOfControllers.append(createNavigationViewControllerForMainController())
        arrayOfControllers.append(createNavigationViewControllerForFavoriteController())
        
        viewControllers = arrayOfControllers
    }
    
    
    private func createNavigationViewControllerForMainController() -> UIViewController {
        let mainViewController = MainViewController()
        mainViewController.viewModel = MainViewControllerViewModel()
        let navigationViewControllerForMainController = UINavigationController(rootViewController: mainViewController)
        mainViewController.title = "Crypto Tracker"
        navigationViewControllerForMainController.title = "Crypto Tracker"
        navigationViewControllerForMainController.tabBarItem.image = UIImage(systemName: "square.grid.3x2.fill")
        return navigationViewControllerForMainController
    }
    
    private func createNavigationViewControllerForFavoriteController() -> UIViewController {
        let favoriteViewController = MainViewController()
        favoriteViewController.viewModel = FavoritCoinsViewControllerViewModel()
        let navigationViewControllerForFavoriteController = UINavigationController(rootViewController: favoriteViewController)
        favoriteViewController.title = "Favorit Coins"
        navigationViewControllerForFavoriteController.title = "Favorit Coins"
        navigationViewControllerForFavoriteController.tabBarItem.image = UIImage(systemName: "star.fill")
        return navigationViewControllerForFavoriteController
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
