
import Foundation
import UIKit

class EntryViewController: UIViewController {

    let containerView = UIView()
    let logoView = UIImageView()
    let loadingView = UIImageView()


    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupSubviews()
        setupLayout()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = EpisodesViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSpinning()
    }

    func addSubviews() {
        view.addSubview(containerView)
        containerView.addSubview(logoView)
        logoView.addSubview(loadingView)
    }

    func setupSubviews() {
        containerView.backgroundColor = .white
        logoView.image = (UIImage(named: "Logo"))
        loadingView.image = (UIImage(named: "LoadingComponent"))
        containerView.clipsToBounds = true
    }
    func setupLayout() {

        containerView.translatesAutoresizingMaskIntoConstraints = false
        logoView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            logoView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 97),
            logoView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 34),
            logoView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -17),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor, multiplier: 0.29),

            loadingView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 200),
            loadingView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

    func startSpinning()  {
        UIView.animate(withDuration: 4, delay: 0, options: .repeat, animations: { () -> Void in
            self.loadingView.transform = self.loadingView.transform.rotated(by: .pi)
        })
    }
}

