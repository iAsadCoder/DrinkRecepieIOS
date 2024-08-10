//
//  FavouritesManager.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 10/08/2024.
//

import CoreData
import UIKit

class FavoritesManager {
    static let shared = FavoritesManager()

    private init() {}

    // Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DrinkModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func addFavorite(drink: Drink) {
        let favoriteDrink = FavoriteDrink(context: context)
        favoriteDrink.idDrink = drink.idDrink
        favoriteDrink.strDrink = drink.strDrink
        favoriteDrink.strAlcoholic = drink.strAlcoholic
        favoriteDrink.strInstructions = drink.strInstructions

        // Save image to file system
        if let imageUrl = URL(string: drink.strDrinkThumb) {
            if let imageData = try? Data(contentsOf: imageUrl) {
                let fileName = UUID().uuidString + ".jpg"
                let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
                try? imageData.write(to: fileURL)
                favoriteDrink.strDrinkThumbPath = fileName
            }
        }

        saveContext()
    }

    func fetchFavorites() -> [Drink] {
        let fetchRequest: NSFetchRequest<FavoriteDrink> = FavoriteDrink.fetchRequest()
        let favoriteDrinks = (try? context.fetch(fetchRequest)) ?? []
        
        return favoriteDrinks.map { drink in
            var drinkModel = Drink(idDrink: drink.idDrink!,
                                   strDrink: drink.strDrink!,
                                   strDrinkThumb: drink.strDrinkThumbPath != nil ? getDocumentsDirectory().appendingPathComponent(drink.strDrinkThumbPath!).absoluteString : "",
                                   strAlcoholic: drink.strAlcoholic!,
                                   strInstructions: drink.strInstructions!)
            drinkModel.isFavorite = true
            return drinkModel
        }
    }

    func removeFavorite(drinkId: String) {
        let fetchRequest: NSFetchRequest<FavoriteDrink> = FavoriteDrink.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idDrink == %@", drinkId)

        if let favoriteDrink = (try? context.fetch(fetchRequest))?.first {
            context.delete(favoriteDrink)
            saveContext()
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
