//
//  FavouritesManager.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 10/08/2024.
//

import Foundation
import CoreData
import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {}

    // Fetching all favorite drinks from Core Data
    func fetchFavorites() -> [Drink] {
        let fetchRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        
        do {
            let favorites = try context.fetch(fetchRequest)
            return favorites.map { Drink(
                idDrink: $0.idDrink ?? "",
                strDrink: $0.strDrink ?? "",
                strDrinkThumb: $0.strDrinkThumb ?? "",
                strAlcoholic: $0.strAlcoholic ?? "",
                strInstructions: $0.strInstructions ?? "",
                isFavorite: true
            )}
        } catch {
            print("Error fetching favorites: \(error)")
            return []
        }
    }
    
    // Adding a drink to favorites
    func addFavorite(drink: Drink) {
        let fetchRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idDrink == %@", drink.idDrink)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.isEmpty {
                let favorite = DrinkEntity(context: context)
                favorite.idDrink = drink.idDrink
                favorite.strDrink = drink.strDrink
                favorite.strDrinkThumb = drink.strDrinkThumb
                favorite.strAlcoholic = drink.strAlcoholic
                favorite.strInstructions = drink.strInstructions
                saveContext()
            }
        } catch {
            print("Error adding favorite: \(error)")
        }
    }
    
    // Removing a drink from favorites
    func removeFavorite(idDrink: String) {
        let fetchRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idDrink == %@", idDrink)
        
        do {
            let results = try context.fetch(fetchRequest)
            for favorite in results {
                context.delete(favorite)
            }
            saveContext()
        } catch {
            print("Error removing favorite: \(error)")
        }
    }
    
    // Saving the context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
