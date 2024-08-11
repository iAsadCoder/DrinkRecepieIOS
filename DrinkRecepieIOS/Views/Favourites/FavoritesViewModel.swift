//
//  FavoritesViewModel.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import Foundation

class FavoritesViewModel {
    private(set) var favoriteDrinks: [Drink] = []

    func fetchFavorites(completion: @escaping () -> Void) {
        // Fetch favorites from FavoritesManager
        favoriteDrinks = FavoritesManager.shared.fetchFavorites()
        completion()
    }
}
