import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DataTransferDelegate {
    var tableData: [String] = [] // Ваши данные будут здесь

    let tableView = UITableView()


    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        setupLayout()

//        fetchData()
    }

    func transferData(_ data: String) {
        if tableData.contains(data) {
            tableData.removeAll {
                $0 == data
            }
        } else {
            tableData.append(data)
        }
        tableView.reloadData()
    }

    func setupLayout() {
        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func fetchData() {
        // Ваш код для выполнения запроса и получения данных
        // Предположим, ваши данные хранятся в массиве strings после выполнения запроса
        let strings = ["Элемент 1", "Элемент 2", "Элемент 3"]
        tableData = strings

        // После получения данных обновите таблицу
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tableData[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Обработка нажатия на ячейку
        print("Вы выбрали \(tableData[indexPath.row])")
    }
}
protocol DataTransferDelegate: AnyObject {
    func transferData(_ data: String)
}

