import Foundation
import UIKit

class FavoritesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, favoriteCellDelegate {
    var favoriteEpisodes = [Episode]()
    let titleLabel = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())


    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupSubviews()
        setupLayout()

    }

    func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
    }
    func setupSubviews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Favourites episodes"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MyCellIdentifier")
        
    }

    func setupLayout() {
        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .vertical
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 47, height: 413)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteEpisodes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCellIdentifier", for: indexPath) as! CollectionViewCell
        let episode = favoriteEpisodes[indexPath.row]

        let stingUrlForCharacter = episode.characters[.random(in: 0..<episode.characters.count)]

        let url2 = URL(string: stingUrlForCharacter)!
        let task2 = URLSession.shared.dataTask(with: url2) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Character.self, from: data)
                    cell.data = response

                    let url3 = URL(string: response.image)!
                    let task3 = URLSession.shared.dataTask(with: url3) { (data2, response2, error) in
                        if let data2 = data2 {
                            let image = UIImage(data: data2)
                            DispatchQueue.main.async {
                                cell.imageView.image = image
                            }
                        } else if let error = error {
                            print("Ошибка запроса: \(error)")
                        }
                    }
                    task3.resume()

                } catch {
                    print("Ошибка при декодировании данных: \(error)")
                }
            } else if let error = error {
                print("Ошибка запроса: \(error)")
            }
        }
        task2.resume()
        cell.cellData = "\(episode.name) | \(episode.episode)"

//        cell.delegate = self
//        cell.delegate2 = favoritesViewController

        cell.videoNameTextView.text = "\(episode.name) | \(episode.episode)"
        cell.characterNameTextView.text = episode.name
        cell.episode = episode
        return cell
    }

    func appendCell(_ cellData: Episode, _ dismiss: Bool) {
        if dismiss {
            favoriteEpisodes.removeAll { $0 == cellData }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            favoriteEpisodes.append(cellData)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    func didTapViewInCell(_ cell: CollectionViewCell, _ data: Character?) {
        if collectionView.indexPath(for: cell) != nil, let data = data {
            let vc =  CharacterDetailsViewController()
            vc.data = data
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: true, completion: nil)
        }
    }

}

