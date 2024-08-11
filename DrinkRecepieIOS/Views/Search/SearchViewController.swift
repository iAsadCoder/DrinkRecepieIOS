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
    @IBOutlet weak var searchTypeSegmentedControl: UISegmentedControl! // Added IBOutlet for segmented control

    private let viewModel = SearchViewModel()
    private var searchType: SearchType = .byName
    private var searchTerm: String = "margarita"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationManager.shared.viewController = self 
        

        
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DrinkCell.self, forCellReuseIdentifier: "DrinkCell")
        
        // Load saved state
        applyLastSearchState()
        searchTerm = UserDefaults.standard.string(forKey: UserDefaultsKeys.searchTerm) ?? "searchTerm"
        fetchDrinks(searchTerm: searchTerm, searchType: searchType)

        // Add target for notifyItem
        notifyItem.target = self
        notifyItem.action = #selector(notifyButtonTapped)
        
        favouritesButton.target = self
        favouritesButton.action = #selector(favouriteButtonTapped)
        
        // Set up the segmented control
        searchTypeSegmentedControl.addTarget(self, action: #selector(searchTypeChanged(_:)), for: .valueChanged)
        searchTypeSegmentedControl.selectedSegmentIndex = 0
        fetchDrinks(searchTerm: "margarita", searchType: .byName)
    }

    @objc private func notifyButtonTapped() {
        NotificationManager.shared.scheduleMealNotification()
    }

    @objc private func favouriteButtonTapped() {
        let storyboard = UIStoryboard(name: "Favourites", bundle: nil)
        if let favoritesVC = storyboard.instantiateViewController(withIdentifier: "FavoritesViewController") as? FavoritesViewController {
            navigationController?.pushViewController(favoritesVC, animated: true)
        }
    }

    private func fetchDrinks(searchTerm: String, searchType: SearchType) {
        viewModel.fetchDrinks(searchTerm: searchTerm, searchType: searchType) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func saveLastSearchType(_ type: SearchType) {
        UserDefaults.standard.set(type.rawValue, forKey: UserDefaultsKeys.lastSearchType)
    }
    
    private func getLastSearchType() -> SearchType {
        if let savedType = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastSearchType),
           let searchType = SearchType(rawValue: savedType) {
            return searchType
        }
        return .byName
    }
    
    private func applyLastSearchState() {
        let lastSearchType = getLastSearchType()
        searchType = lastSearchType
        
        switch lastSearchType {
        case .byName:
            searchTypeSegmentedControl.selectedSegmentIndex = 0
        case .byAlphabet:
            searchTypeSegmentedControl.selectedSegmentIndex = 1
        }
    }
    
    @objc private func searchTypeChanged(_ sender: UISegmentedControl) {
        let selectedType: SearchType
        switch sender.selectedSegmentIndex {
        case 0:
            selectedType = .byName
        case 1:
            selectedType = .byAlphabet
        default:
            return
        }
        searchType = selectedType
        saveLastSearchType(selectedType)
        fetchDrinks(searchTerm: searchTerm, searchType: searchType)
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
        
        let storyboard = UIStoryboard(name: "DrinkDetails", bundle: nil)
        if let drinkDetailsVC = storyboard.instantiateViewController(withIdentifier: "DrinkDetailsViewController") as? DrinkDetailsViewController {
            drinkDetailsVC.drink = drink
            navigationController?.pushViewController(drinkDetailsVC, animated: true)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerm = searchText
        UserDefaults.standard.set(searchTerm, forKey: UserDefaultsKeys.searchTerm)
        fetchDrinks(searchTerm: searchTerm, searchType: searchType)
    }
}
