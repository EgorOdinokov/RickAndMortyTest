
import Foundation
import UIKit

class MainViewController: UIViewController  {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let titleImage = UIImageView()
    let searchView = UILabel()
    let filterView = UILabel()
    weak var favoritesViewController: FavoritesViewController?
    var episodes: [Episode] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupSubviews()
        setupLayout()

        let url = URL(string: "https://rickandmortyapi.com/api/episode")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Response.self, from: data)
                    self.episodes = response.results
                    // Обновление collectionView на основе полученных данных

                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                } catch {
                    print("Ошибка при декодировании данных: \(error)")
                }
            } else if let error = error {
                print("Ошибка запроса: \(error)")
            }
        }
        task.resume()
    }
    func addSubviews() {
        view.addSubview(titleImage)
        view.addSubview(searchView)
        view.addSubview(filterView)
        view.addSubview(collectionView)
    }
    func setupSubviews() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        titleImage.translatesAutoresizingMaskIntoConstraints = false
        searchView.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        searchView.backgroundColor = .gray
        filterView.backgroundColor = .lightGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MyCellIdentifier")
        titleImage.image = (UIImage(named: "Logo"))

    }
    func setupLayout() {
        NSLayoutConstraint.activate([

            titleImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            titleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            titleImage.heightAnchor.constraint(equalTo: titleImage.widthAnchor, multiplier: 0.29),

            searchView.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 67),
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            searchView.heightAnchor.constraint(equalToConstant: 56),

            filterView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 12),
            filterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            filterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            filterView.heightAnchor.constraint(equalToConstant: 56),

            collectionView.topAnchor.constraint(equalTo: filterView.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .vertical
    }

}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MyCollectionViewCellDelegate {

    func didTapViewInCell(_ cell: CollectionViewCell) {
        if collectionView.indexPath(for: cell) != nil {
            let vc = UINavigationController(rootViewController: CharacterDetailsViewController())
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            }
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return episodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCellIdentifier", for: indexPath) as! CollectionViewCell

        let episode = episodes[indexPath.item]

        cell.cellData = "\(episode.name) | \(episode.episode)"
        
        cell.delegate = self

        cell.favotitesDelegate = favoritesViewController

        cell.videoNameTextView.text = "\(episode.name) | \(episode.episode)"
        cell.characterNameTextView.text = episode.name
          return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 47, height: 413)
    }
}

struct Episode: Codable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    // Добавьте другие свойства эпизода, если это необходимо
    enum CodingKeys: String, CodingKey {
            case id
            case name
            case airDate = "air_date"
            case episode
        }

}

struct Response: Codable {
    let results: [Episode]
}


