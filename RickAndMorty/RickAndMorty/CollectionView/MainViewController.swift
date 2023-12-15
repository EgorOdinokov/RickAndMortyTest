
import Foundation
import UIKit

class MainViewController: UIViewController, UISearchBarDelegate  {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let titleImage = UIImageView()
    let mySearchBar = UISearchBar()
    let filterButton = UIButton()
    let filterButton1 = UIButton()
    let filterButton2 = UIButton()
    let filterButton3 = UIButton()
    var isFiltering = Bool()
    var filteredCells = [Episode]()
    var character = [Character]()
    var stingUrlForCharacter = String()
    var episodes: [Episode] = []
    weak var favoritesViewController: FavoritesViewController?

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
                    print(self.stingUrlForCharacter)
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
        view.addSubview(mySearchBar)
        view.addSubview(filterButton)
        view.addSubview(filterButton1)
        view.addSubview(filterButton2)
        view.addSubview(filterButton3)
        view.addSubview(collectionView)
    }
    func setupSubviews() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        titleImage.translatesAutoresizingMaskIntoConstraints = false
        mySearchBar.translatesAutoresizingMaskIntoConstraints = false
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton1.translatesAutoresizingMaskIntoConstraints = false
        filterButton2.translatesAutoresizingMaskIntoConstraints = false
        filterButton3.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "MyCellIdentifier")
        titleImage.image = (UIImage(named: "Logo"))

        mySearchBar.placeholder = "Name or episode (ex.S01E01)..."
        mySearchBar.delegate = self
        mySearchBar.searchBarStyle = .minimal
        mySearchBar.layer.borderWidth = 1
        mySearchBar.layer.borderColor = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        filterButton.backgroundColor = UIColor(red: 0.89, green: 0.95, blue: 0.99, alpha: 1)
        filterButton.setTitle("ADVANCED FILTERS", for: .normal)
        filterButton.setTitleColor(UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1), for: .normal)
        filterButton.layer.cornerRadius = 4
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterButton.addGestureRecognizer(tapGesture)

        filterButton1.backgroundColor = .lightGray
        filterButton1.setTitle("NAME", for: .normal)
        filterButton1.isHidden = true
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped1))
        filterButton1.addGestureRecognizer(tapGesture1)

        filterButton2.backgroundColor = .lightGray
        filterButton2.setTitle("EPISODE", for: .normal)
        view.bringSubviewToFront(filterButton2)
        filterButton2.isHidden = true
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped2))
        filterButton2.addGestureRecognizer(tapGesture2)

        filterButton3.backgroundColor = .lightGray
        filterButton3.setTitle("ALL", for: .normal)
        view.bringSubviewToFront(filterButton3)
        filterButton3.isHidden = true
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped3))
        filterButton3.addGestureRecognizer(tapGesture3)

    }
    func setupLayout() {
        NSLayoutConstraint.activate([

            titleImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 57),
            titleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            titleImage.heightAnchor.constraint(equalTo: titleImage.widthAnchor, multiplier: 0.29),

            mySearchBar.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 67),
            mySearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            mySearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -22),
            mySearchBar.heightAnchor.constraint(equalToConstant: 56),

            filterButton.topAnchor.constraint(equalTo: mySearchBar.bottomAnchor, constant: 12),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            filterButton.heightAnchor.constraint(equalToConstant: 56),

            filterButton1.topAnchor.constraint(equalTo: mySearchBar.bottomAnchor, constant: 12),
            filterButton1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            filterButton1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            filterButton1.heightAnchor.constraint(equalToConstant: 56),

            filterButton2.topAnchor.constraint(equalTo: filterButton1.bottomAnchor),
            filterButton2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            filterButton2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            filterButton2.heightAnchor.constraint(equalToConstant: 56),

            filterButton3.topAnchor.constraint(equalTo: filterButton2.bottomAnchor),
            filterButton3.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 21),
            filterButton3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            filterButton3.heightAnchor.constraint(equalToConstant: 56),

            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .vertical
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let filteredItems = episodes.filter {
            $0.name.contains(searchText) || $0.episode.contains(searchText)
        }
        if searchText.isEmpty {
            isFiltering = false
        } else {
            isFiltering = true
        }
        filteredCells = filteredItems
        collectionView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MyCollectionViewCellDelegate {

    func didTapViewInCell(_ cell: CollectionViewCell, _ data: Character?) {
        if collectionView.indexPath(for: cell) != nil, let data = data {
            let vc =  CharacterDetailsViewController()
            vc.data = data
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: true, completion: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCells.count
        } else {
            return episodes.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCellIdentifier", for: indexPath) as! CollectionViewCell
        let episode: Episode
        if isFiltering {
            episode = filteredCells[indexPath.item]
        } else {
            episode = episodes[indexPath.item]
        }

        stingUrlForCharacter = episode.characters[.random(in: 0..<episode.characters.count)]

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

        cell.delegate = self
        cell.delegate2 = favoritesViewController

        cell.videoNameTextView.text = "\(episode.name) | \(episode.episode)"
        cell.characterNameTextView.text = episode.name
        cell.episode = episode
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 47, height: 413)
    }

    @objc
    func filterButtonTapped() {
        filterButton1.isHidden = false
        filterButton2.isHidden = false
        filterButton3.isHidden = false
    }

    @objc
    func filterButtonTapped1() {
        filterButton.setTitle("ADVANCED FILTERS(NAME)", for: .normal)
        filterButton1.isHidden = true
        filterButton2.isHidden = true
        filterButton3.isHidden = true
    }

    @objc
    func filterButtonTapped2() {
        filterButton.setTitle("ADVANCED FILTERS(EPISODE)", for: .normal)
        filterButton1.isHidden = true
        filterButton2.isHidden = true
        filterButton3.isHidden = true
    }

    @objc
    func filterButtonTapped3() {
        filterButton.setTitle("ADVANCED FILTERS(ALL)", for: .normal)
        filterButton1.isHidden = true
        filterButton2.isHidden = true
        filterButton3.isHidden = true
    }
}

struct Episode: Codable, Equatable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
        case characters
    }
}

struct Response: Codable {
    let results: [Episode]
}

struct Character: Codable {
    let name: String
    let gender: String
    let status: String
    let species: String
    let origin: Origin
    let type: String
    let location: Location
    let image: String
}

struct Location: Codable {
    let name: String
    let url: String
}

struct Origin: Codable {
    let name: String
    let url: String
}


