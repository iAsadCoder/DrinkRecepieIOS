//
//  SearchViewController.swift
//  DrinkRecepieIOS
//
//  Created by iAsad on 09/08/2024.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var notifyItem: UIBarButtonItem!
    
    @IBOutlet weak var favouritesButton: UIBarButtonItem!
    
    

    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DrinkCell.self, forCellReuseIdentifier: "DrinkCell")
        
        fetchDrinks(searchTerm: "margarita")
        // Add target for notifyItem
                notifyItem.target = self
                notifyItem.action = #selector(notifyButtonTapped)
        
        favouritesButton.target = self
        favouritesButton.action = #selector(favouriteButtonTapped)

    }

    @objc private func notifyButtonTapped() {
        NotificationManager.shared.scheduleDailyNotification()
    }

    @objc private func favouriteButtonTapped() {
       
        let storyboard = UIStoryboard(name: "Favourites", bundle: nil) // Replace "Main" with your storyboard name if different
        if let FavoritesVC = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
          //  drinkDetailsVC.drink = drink // Pass the selected drink to the DrinkDetailsViewController
            navigationController?.pushViewController(FavoritesVC, animated: true)
        }
    }
    private func fetchDrinks(searchTerm: String) {
        viewModel.fetchDrinks(searchTerm: searchTerm) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.drinks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrinkCell", for: indexPath) as! DrinkCell
        if let drink = viewModel.getDrink(at: indexPath.row) {
            cell.configure(with: drink)
            cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        }
        return cell
    }

    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? DrinkCell,
              let indexPath = tableView.indexPath(for: cell),
              let drink = viewModel.getDrink(at: indexPath.row) else { return }

        viewModel.toggleFavorite(drinkId: drink.idDrink)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let drink = viewModel.getDrink(at: indexPath.row) else { return }
        
        let storyboard = UIStoryboard(name: "DrinkDetails", bundle: nil) // Replace "Main" with your storyboard name if different
        if let drinkDetailsVC = storyboard.instantiateViewController(withIdentifier: "DrinkDetailsViewController") as? DrinkDetailsViewController {
            drinkDetailsVC.drink = drink // Pass the selected drink to the DrinkDetailsViewController
            navigationController?.pushViewController(drinkDetailsVC, animated: true)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fetchDrinks(searchTerm: searchText)
    }
}
