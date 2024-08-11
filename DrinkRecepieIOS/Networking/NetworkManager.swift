//
//  NetworkManager.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchDrinks(searchTerm: String, completion: @escaping (Result<[Drink], Error>) -> Void) {
        let url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchTerm)"
        AF.request(url).responseDecodable(of: DrinkResponse.self) { response in
            switch response.result {
            case .success(let drinkResponse):
                completion(.success(drinkResponse.drinks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
