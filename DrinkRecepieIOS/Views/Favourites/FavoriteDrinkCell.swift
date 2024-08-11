//
//  FavoriteDrinkCell.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import UIKit
import SDWebImage

class FavoriteDrinkCell: UITableViewCell {
    
    let drinkImageView = UIImageView()
    let drinkNameLabel = UILabel()
    let drinkTypeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        drinkImageView.contentMode = .scaleAspectFill
        drinkImageView.clipsToBounds = true
        drinkImageView.layer.cornerRadius = 25
        drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        drinkNameLabel.translatesAutoresizingMaskIntoConstraints = false
        drinkTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(drinkImageView)
        contentView.addSubview(drinkNameLabel)
        contentView.addSubview(drinkTypeLabel)
        
        // Configure labels
        drinkNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        drinkTypeLabel.font = UIFont.systemFont(ofSize: 14)
        drinkTypeLabel.textColor = .gray
        
        NSLayoutConstraint.activate([
            
            drinkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            drinkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            drinkImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            drinkImageView.widthAnchor.constraint(equalToConstant: 50),
            drinkImageView.heightAnchor.constraint(equalToConstant: 50),
            
            drinkNameLabel.leadingAnchor.constraint(equalTo: drinkImageView.trailingAnchor, constant: 16),
            drinkNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            drinkNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            drinkTypeLabel.leadingAnchor.constraint(equalTo: drinkNameLabel.leadingAnchor),
            drinkTypeLabel.trailingAnchor.constraint(equalTo: drinkNameLabel.trailingAnchor),
            drinkTypeLabel.topAnchor.constraint(equalTo: drinkNameLabel.bottomAnchor, constant: 4),
            drinkTypeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with drink: Drink) {
        drinkNameLabel.text = drink.strDrink
        drinkTypeLabel.text = drink.strAlcoholic
        
        if let url = URL(string: drink.strDrinkThumb) {
            drinkImageView.sd_setImage(with: url, completed: nil)
        } else {
            drinkImageView.image = nil
        }
    }
}


extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
