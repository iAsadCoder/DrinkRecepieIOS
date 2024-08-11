//
//  DrinkDetailsViewModel.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import Foundation

class DrinkDetailViewModel {
    private var drink: Drink?

    func setDrink(drink: Drink) {
        self.drink = drink
    }

    func getDrink() -> Drink? {
        return drink
    }
}
