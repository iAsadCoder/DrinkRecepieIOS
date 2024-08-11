//
//  DrinkDetailViewController.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//





import UIKit
import SDWebImage // Import SDWebImage for image caching

class DrinkDetailsViewController: UIViewController {
    var drink: Drink?

    private let drinkImageView = UIImageView()
    private let drinkNameLabel = UILabel()
    private let drinkTypeLabel = UILabel()
    private let alcoholicLabel = UILabel()
    private let descriptionLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        configure(with: drink)
    }

    private func setupSubviews() {
        drinkImageView.contentMode = .scaleAspectFill
        drinkImageView.clipsToBounds = true
        drinkImageView.layer.cornerRadius = 25
        view.addSubview(drinkImageView)

        drinkNameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        view.addSubview(drinkNameLabel)

        drinkTypeLabel.font = .systemFont(ofSize: 18)
        drinkTypeLabel.textColor = .gray
        view.addSubview(drinkTypeLabel)

        alcoholicLabel.font = .systemFont(ofSize: 18)
        view.addSubview(alcoholicLabel)

        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)

        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        alcoholicLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            drinkImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            drinkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            drinkImageView.widthAnchor.constraint(equalToConstant: 100),
            drinkImageView.heightAnchor.constraint(equalToConstant: 100),

            drinkNameLabel.topAnchor.constraint(equalTo: drinkImageView.bottomAnchor, constant: 16),
            drinkNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            drinkTypeLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 8),
            drinkTypeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            alcoholicLabel.topAnchor.constraint(equalTo: drinkTypeLabel.bottomAnchor, constant: 8),
            alcoholicLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: alcoholicLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    func configure(with drink: Drink?) {
        guard let drink = drink else { return }
        drinkNameLabel.text = drink.strDrink
        drinkTypeLabel.text = drink.strAlcoholic
        alcoholicLabel.text = drink.strAlcoholic == "Alcoholic" ? "🍹" : "🍸"
        descriptionLabel.text = drink.strInstructions

        if let imageUrl = URL(string: drink.strDrinkThumb) {
            // Use SDWebImage to load and cache the image
            drinkImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
        } else {
            drinkImageView.image = UIImage(systemName: "photo") // Default image
        }
    }
}
