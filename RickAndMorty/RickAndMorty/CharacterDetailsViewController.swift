import Foundation
import UIKit
import AVFoundation
import Photos

class CharacterDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var data: Character?
    let avatarView = UIImageView()
    let changeAvatarButton = UIButton()
    let nameLabel = UILabel()
    let infoLabel = UILabel()
    let tableView = UITableView()
    var tableTitles = [String]()
    var tableData = [String]()
    let imagePicker = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupSubviews()
        setupLayout()

        view.backgroundColor = .white

        self.navigationController?.setNavigationBarHidden(false, animated: false)

        let backButton = UIBarButtonItem(image: UIImage(named: "arrow_left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = .black
        let goBack = UILabel()
        goBack.text = "GO BACK"
        goBack.font = UIFont.boldSystemFont(ofSize: 18)
        NSLayoutConstraint.activate([goBack.widthAnchor.constraint(equalToConstant: 265)])
        goBack.textAlignment = .left

        let rightImageView = UIImageView(image: UIImage(named: "character_details_nav_logo"))
        let rightBarButton = UIBarButtonItem(customView: rightImageView)

        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.leftBarButtonItem = backButton
        navigationItem.titleView = goBack

    }

    @objc
    func backButtonTapped() {
                self.dismiss(animated: true)
    }
    
    func addSubviews() {
        view.addSubview(avatarView)
        view.addSubview(changeAvatarButton)
        view.addSubview(nameLabel)
        view.addSubview(infoLabel)
        view.addSubview(tableView)
    }
    func setupSubviews() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        changeAvatarButton.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let url = URL(string: data!.image)!
        let task3 = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.avatarView.image = image
                }
            } else if let error = error {
                print("Ошибка запроса: \(error)")
            }
        }
        task3.resume()

        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 75
        avatarView.layer.borderWidth = 5
        avatarView.layer.borderColor = CGColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1)

        changeAvatarButton.setImage(UIImage(named: "Camera"), for: .normal)
        changeAvatarButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        imagePicker.delegate = self



        nameLabel.text = data!.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 32)

        infoLabel.text = "Informations"
        infoLabel.textColor = UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
        infoLabel.font = UIFont.boldSystemFont(ofSize: 20)

        tableTitles.append("Gender")
        tableTitles.append("Status")
        tableTitles.append("Species")
        tableTitles.append("Origin")
        tableTitles.append("Type")
        tableTitles.append("Location")

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        if data!.gender == "" {
            tableData.append("Unknown")
        } else {
            tableData.append(data!.gender)
        }
        if data!.status == "" {
            tableData.append("Unknown")
        } else {
            tableData.append(data!.status)
        }
        if data!.species == "" {
            tableData.append("Unknown")
        } else {
            tableData.append(data!.species)
        }
        if data!.origin.name == "" {
            tableData.append("Unknown")
        } else {
            tableData.append(data!.origin.name)
        }
        if data!.type == "" {
            tableData.append("Unknown")
        } else {
            tableData.append(data!.type)
        }
        if data!.location.name == "" {
            tableData.append("Unknown")
        } else {
            tableData.append(data!.location.name)
        }

        tableView.reloadData()

    }
    func setupLayout() {
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 148),
            avatarView.widthAnchor.constraint(equalToConstant: 147),

            changeAvatarButton.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            changeAvatarButton.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 9),
            changeAvatarButton.heightAnchor.constraint(equalToConstant: 32),
            changeAvatarButton.widthAnchor.constraint(equalToConstant: 32),

            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 47),
            nameLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 38),

            infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 18),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let tittleLabel = UILabel()
        let infoLabel = UILabel()
        tittleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        tittleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        tittleLabel.text = tableTitles[indexPath.row]
        infoLabel.font.withSize(14)
        infoLabel.textColor = UIColor(red: 0.43, green: 0.47, blue: 0.55, alpha: 1)
        infoLabel.text = tableData[indexPath.row]
        cell.addSubview(tittleLabel)
        cell.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            tittleLabel.topAnchor.constraint(equalTo: cell.topAnchor, constant: 9),
            tittleLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16),

            infoLabel.topAnchor.constraint(equalTo: tittleLabel.bottomAnchor),
            infoLabel.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 16)
        ])

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

    @objc func buttonAction(sender: UIButton!) {

            showPhotoSourceOptions()
    }

    func openCamera() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if cameraAuthorizationStatus == .notDetermined {
            requestCameraAndLibraryAccess()
        } else if cameraAuthorizationStatus == .denied {
            showSettingsAlert()
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true, completion: nil)
            } else {
                print("Камера недоступна")
            }
        }
    }

    func openGallery() {
        let photoLibraryAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photoLibraryAuthorizationStatus == .notDetermined {
            requestCameraAndLibraryAccess()
        } else if photoLibraryAuthorizationStatus == .denied {
            showSettingsAlert()
        } else {
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            self.avatarView.image = pickedImage
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func requestCameraAndLibraryAccess() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.showSettingsAlert()
                } else {
                    PHPhotoLibrary.requestAuthorization { status in
                        if status == .denied {
                            self.showSettingsAlert()
                        } else if status == .authorized {
                            DispatchQueue.main.async {
                                self.showPhotoSourceOptions()
                            }
                        }
                    }
                }
            }
        }
    }

    func showSettingsAlert() {
        let alert = UIAlertController(title: "Access denied", message: "Please go to Settings to enable camera and photo library access", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { action in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    func showPhotoSourceOptions() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "Камера", style: .default, handler: { action in
            self.openCamera()
        }))

        actionSheet.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { action in
            self.openGallery()
        }))

        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }
}
