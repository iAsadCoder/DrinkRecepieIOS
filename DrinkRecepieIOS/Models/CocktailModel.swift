//
//  CocktailModel.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import Foundation

struct DrinkResponse: Codable {
    let drinks: [Drink]
}

struct Drink: Codable {
    let idDrink: String
    let strDrink: String
    let strDrinkThumb: String
    let strAlcoholic: String
    var isFavorite: Bool 
    var strInstructions: String
    
    
    

    enum CodingKeys: String, CodingKey {
        case idDrink
        case strDrink
        case strDrinkThumb
        case strAlcoholic
        case isFavorite
        case strInstructions
    }

    init(idDrink: String, strDrink: String, strDrinkThumb: String, strAlcoholic: String, strInstructions: String, isFavorite: Bool = false) {
        self.idDrink = idDrink
        self.strDrink = strDrink
        self.strDrinkThumb = strDrinkThumb
        self.strAlcoholic = strAlcoholic
        self.isFavorite = isFavorite
        self.strInstructions = strInstructions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idDrink = try container.decode(String.self, forKey: .idDrink)
        strDrink = try container.decode(String.self, forKey: .strDrink)
        strDrinkThumb = try container.decode(String.self, forKey: .strDrinkThumb)
        strAlcoholic = try container.decode(String.self, forKey: .strAlcoholic)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
    }
}
