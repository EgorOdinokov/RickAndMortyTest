
import Foundation
import UIKit

class EpisodesViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.barTintColor = .white
        view.backgroundColor = .white
        tabBar.itemPositioning = .centered
        self.tabBar.frame.size.height = 61

        let homeViewController = MainViewController()
        let favoritesViewController = FavoritesViewController()

        homeViewController.favoritesViewController = favoritesViewController

        homeViewController.tabBarItem = UITabBarItem(
        title: nil,
        image: UIImage(named: "House"),
        selectedImage: UIImage(named: "FilledHouse")
        )

        favoritesViewController.tabBarItem = UITabBarItem(
        title: nil,
        image: UIImage(named: "Heart"),
        selectedImage: UIImage(named: "FilledHeart")
        )

        let viewControllers = [UINavigationController(rootViewController: homeViewController), UINavigationController(rootViewController: favoritesViewController)]
        self.viewControllers = viewControllers

    }
}

