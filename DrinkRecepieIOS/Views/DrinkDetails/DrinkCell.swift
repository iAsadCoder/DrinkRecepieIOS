//
//  DrinkCell.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.





import UIKit
import SDWebImage 
protocol DrinkCellDelegate: AnyObject {
    func didTapFavoriteButton(in cell: DrinkCell)
}

class DrinkCell: UITableViewCell {
     let drinkImageView = UIImageView()
     let drinkNameLabel = UILabel()
     let favoriteButton = UIButton()
     let alcoholicLabel = UILabel()
     let drinkTypeLabel = UILabel()
   
    weak var delegate: DrinkCellDelegate?
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        drinkImageView.contentMode = .scaleAspectFill
        drinkImageView.clipsToBounds = true
        drinkImageView.layer.cornerRadius = 25
        contentView.addSubview(drinkImageView)
        contentView.addSubview(drinkNameLabel)
        contentView.addSubview(favoriteButton)
        contentView.addSubview(alcoholicLabel)
        contentView.addSubview(drinkTypeLabel)
       
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
       
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        alcoholicLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkTypeLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            drinkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            drinkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            drinkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            drinkImageView.widthAnchor.constraint(equalToConstant: 50),
            drinkImageView.heightAnchor.constraint(equalToConstant: 50),
           
            drinkNameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 16),
            drinkNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            drinkNameLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -16),
           
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
           
            alcoholicLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            alcoholicLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            drinkTypeLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            drinkTypeLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            drinkTypeLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 4),
            drinkTypeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8) // Adjusted to give it some margin
        ])

        // Allow multiline text
        drinkNameLabel.numberOfLines = 0
        drinkNameLabel.lineBreakMode = .byWordWrapping
        drinkNameLabel.font = UIFont.systemFont(ofSize: 16)
        drinkTypeLabel.font = UIFont.systemFont(ofSize: 14)
        drinkTypeLabel.textColor = .gray
    }

    @objc private func favoriteButtonTapped() {
        delegate?.didTapFavoriteButton(in: self)
    }

    func configure(with drink: Drink) {
        drinkNameLabel.text = drink.strDrink
        drinkTypeLabel.text = drink.strAlcoholic
        alcoholicLabel.text = drink.strAlcoholic == "Alcoholic" ? "🍹" : "🍸"
        favoriteButton.isSelected = drink.isFavorite
        
        if let imageUrl = URL(string: drink.strDrinkThumb) {
            drinkImageView.sd_setImage(with: imageUrl, completed: nil)
        } else {
            drinkImageView.image = UIImage(systemName: "photo") // Default image
        }
    }
}
