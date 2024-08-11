//
//  FavouritesViewController.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

//import UIKit
//
//class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    private let viewModel = FavoritesViewModel()
//    private let tableView = UITableView()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        viewModel.fetchFavorites {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//    private func setupTableView() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.addSubview(tableView)
//        tableView.frame = view.bounds
//        tableView.register(FavoriteDrinkCell.self, forCellReuseIdentifier: "FavoriteDrinkCell")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.favoriteDrinks.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteDrinkCell", for: indexPath) as! FavoriteDrinkCell
//        let drink = viewModel.favoriteDrinks[indexPath.row]
//        cell.configure(with: drink)
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let drink = viewModel.favoriteDrinks[safe: indexPath.row] else { return }
//
//        let storyboard = UIStoryboard(name: "DrinkDetails", bundle: nil) // Replace with your storyboard name if different
//        if let drinkDetailsVC = storyboard.instantiateViewController(withIdentifier: "DrinkDetailsViewController") as? DrinkDetailsViewController {
//            drinkDetailsVC.drink = drink // Pass the selected drink to the DrinkDetailsViewController
//            navigationController?.pushViewController(drinkDetailsVC, animated: true)
//        }
//    }
//}


import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let viewModel = FavoritesViewModel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.fetchFavorites {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(FavoriteDrinkCell.self, forCellReuseIdentifier: "FavoriteDrinkCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoriteDrinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteDrinkCell", for: indexPath) as! FavoriteDrinkCell
        let drink = viewModel.favoriteDrinks[indexPath.row]
        cell.configure(with: drink)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let drink = viewModel.favoriteDrinks[safe: indexPath.row] else { return }

        let storyboard = UIStoryboard(name: "DrinkDetails", bundle: nil) // Replace with your storyboard name if different
        if let drinkDetailsVC = storyboard.instantiateViewController(withIdentifier: "DrinkDetailsViewController") as? DrinkDetailsViewController {
            drinkDetailsVC.drink = drink // Pass the selected drink to the DrinkDetailsViewController
            navigationController?.pushViewController(drinkDetailsVC, animated: true)
        }
    }
}
