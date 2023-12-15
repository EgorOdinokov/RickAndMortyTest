import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    let containerView = UIView()
    let imageView = UIImageView()
    let characterNameContainerView = UILabel()
    let characterNameTextView = UILabel()
    let videoNameContainerView = UILabel()
    let videoNameImageView = UIImageView()
    let videoNameTextView = UILabel()
    let isFavoriteView = UIImageView()
    var data: Character?
    var cellData: String = ""
    var episode: Episode?

    weak var delegate: MyCollectionViewCellDelegate?
    weak var delegate2: favoriteCellDelegate?

    @objc func didTapFavorite() {
        guard let episode else { return }
        if self.isFavoriteView.image == UIImage(named: "Heart") {
            self.isFavoriteView.image = UIImage(named: "Filled_Heart")
            delegate2?.appendCell(episode, false)
        } else {
            self.isFavoriteView.image = UIImage(named: "Heart")
            delegate2?.appendCell(episode, true)
        }
    }


    @objc
    func imageViewTapped() {
        delegate?.didTapViewInCell(self, data)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupSubviews()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubviews() {

        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(characterNameContainerView)
        characterNameContainerView.addSubview(characterNameTextView)
        containerView.addSubview(videoNameContainerView)
        videoNameContainerView.addSubview(videoNameTextView)
        videoNameContainerView.addSubview(videoNameImageView)
        containerView.addSubview(isFavoriteView)

    }

    func setupSubviews() {

        videoNameContainerView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        videoNameContainerView.layer.cornerRadius = 16
        videoNameImageView.image = UIImage(named: "MonitorPlay")
        isFavoriteView.image = UIImage(named: "Heart")

        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapGesture)

        isFavoriteView.isUserInteractionEnabled = true
        let tapGestureFavorite = UITapGestureRecognizer(target: self, action: #selector(didTapFavorite))
        isFavoriteView.addGestureRecognizer(tapGestureFavorite)
    }

    func setupLayout() {

        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        characterNameContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoNameContainerView.translatesAutoresizingMaskIntoConstraints = false
        videoNameContainerView.clipsToBounds = true
        isFavoriteView.translatesAutoresizingMaskIntoConstraints = false
        characterNameTextView.translatesAutoresizingMaskIntoConstraints = false
        videoNameTextView.translatesAutoresizingMaskIntoConstraints = false
        videoNameImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 288),

            characterNameContainerView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            characterNameContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            characterNameContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            characterNameContainerView.heightAnchor.constraint(equalToConstant: 54),

            characterNameTextView.centerYAnchor.constraint(equalTo: characterNameContainerView.centerYAnchor),
            characterNameTextView.leadingAnchor.constraint(equalTo: characterNameContainerView.leadingAnchor, constant: 20),
            characterNameTextView.heightAnchor.constraint(equalToConstant: 20),

            videoNameContainerView.topAnchor.constraint(equalTo: characterNameContainerView.bottomAnchor),
            videoNameContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            videoNameContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            videoNameContainerView.heightAnchor.constraint(equalToConstant: 71),

            videoNameImageView.centerYAnchor.constraint(equalTo: videoNameContainerView.centerYAnchor),
            videoNameImageView.leadingAnchor.constraint(equalTo: videoNameContainerView.leadingAnchor, constant: 20),

            videoNameTextView.centerYAnchor.constraint(equalTo: videoNameContainerView.centerYAnchor),
            videoNameTextView.leadingAnchor.constraint(equalTo: videoNameImageView.trailingAnchor, constant: 20),
            videoNameTextView.trailingAnchor.constraint(lessThanOrEqualTo: isFavoriteView.leadingAnchor),
            videoNameTextView.heightAnchor.constraint(equalToConstant: 20),

            isFavoriteView.topAnchor.constraint(equalTo: videoNameContainerView.topAnchor, constant: 17),
            isFavoriteView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18),
            isFavoriteView.heightAnchor.constraint(equalToConstant: 40),
            isFavoriteView.widthAnchor.constraint(equalToConstant: 41)
        ])
    }
}

protocol MyCollectionViewCellDelegate: AnyObject {
    func didTapViewInCell(_ cell: CollectionViewCell, _ data: Character?)
}

protocol favoriteCellDelegate: AnyObject {
    func appendCell(_ cellData: Episode, _ dismiss: Bool)
}

