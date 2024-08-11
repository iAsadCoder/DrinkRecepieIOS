//
//  SearchViewModel.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//



import Foundation

class SearchViewModel {
    private(set) var drinks: [Drink] = []
    
    func fetchDrinks(searchTerm: String, completion: @escaping () -> Void) {
        NetworkManager.shared.fetchDrinks(searchTerm: searchTerm) { result in
            switch result {
            case .success(let drinks):
                self.drinks = drinks
                self.updateFavoriteStatus()
                completion()
            case .failure(let error):
                print("Error fetching drinks: \(error)")
            }
        }
    }

    func getDrink(at index: Int) -> Drink? {
        guard index >= 0 && index < drinks.count else { return nil }
        return drinks[index]
    }

    func toggleFavorite(drinkId: String) {
        let favorites = FavoritesManager.shared.fetchFavorites()
        if favorites.contains(where: { $0.idDrink == drinkId }) {
            FavoritesManager.shared.removeFavorite(idDrink: drinkId)
        } else {
            // Fetch the drink details if needed
            if let drink = drinks.first(where: { $0.idDrink == drinkId }) {
                FavoritesManager.shared.addFavorite(drink: drink)
            }
        }
        updateFavoriteStatus()
    }

    private func updateFavoriteStatus() {
        let favoriteIds = FavoritesManager.shared.fetchFavorites().map { $0.idDrink }
        for index in 0..<drinks.count {
            drinks[index].isFavorite = favoriteIds.contains(drinks[index].idDrink)
        }
    }
}
