import Foundation
import UIKit

class CharacterDetailsViewController: UIViewController {


    @objc
    func backButtonTapped() {
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        let backButton = UIBarButtonItem(image: UIImage(named: "arrow_left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        backButton.title = "GO BACK"
        navigationItem.leftBarButtonItem = backButton

        let rightImage = UIImage(named: "character_details_nav_logo")
        let rightImageView = UIImageView(image: rightImage)
        let rightBarButton = UIBarButtonItem(customView: rightImageView)

        navigationItem.rightBarButtonItem = rightBarButton


    }
}
