//
//  UserDefaultKeys.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 11/08/2024.
//

import Foundation

// Define the keys and enum for UserDefaults
struct UserDefaultsKeys {
    static let lastSearchType = "lastSearchType"
    static let searchTerm = "searchTerm"
}

enum SearchType: String {
    case byName = "SearchByName"
    case byAlphabet = "SearchByAlphabet"
}
