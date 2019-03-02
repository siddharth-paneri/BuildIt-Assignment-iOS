//
//  FindCityViewController.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit

class FindCityViewController: SuperViewController {

    @IBOutlet weak var tableView: UITableView!
    private var citiesFileViewModels = CitiesFileViewModel()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Find City"
        // setup initial view and components
        setupSearchController()
        setupTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewModelObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.showLoadingView(with: "Loading cities")
        citiesFileViewModels.fetchCitiesFromFile()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeViewModelObservers()
    }
    //MARK:-
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Enter City name or country"
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupViewModelObservers() {
        // set up viewModel did update
        citiesFileViewModels.didUpdate = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.refreshUI()
            weakSelf.hideLoadingView()
        }
        
        // set up viewModel didFail
        citiesFileViewModels.didFail = { [weak self] (weatherError) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.hideLoadingView()
            guard let error = weatherError else {
                return
            }
            let tupple = error.tupple
            weakSelf.showError(withTitle: tupple.title, message: tupple.message)
            
        }
    }
    
    private func removeViewModelObservers() {
        citiesFileViewModels.didUpdate = nil
        citiesFileViewModels.didFail = nil
    }
    
    /** Refresh UI */
    private func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.tableView.reloadData()
        }
    }
}

//MARK:- UISearchBarDelegate & UISearchResultsUpdating
extension FindCityViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if !searchText.isEmpty {
                // filter the cities based on search text
                citiesFileViewModels.filterString = searchText
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        citiesFileViewModels.filterString = ""
        self.refreshUI()
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension FindCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesFileViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindCityCell", for: indexPath)
        // get the CityViewModel for given cel
        guard let city = citiesFileViewModels.viewModel(at: indexPath.row) else {
            return UITableViewCell(frame: .zero)
        }
        cell.textLabel?.text = city.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = citiesFileViewModels.viewModel(at: indexPath.row) else {
            return
        }
        print("Selected city - \(city.name)")
        city.save()
        self.navigationController?.popViewController(animated: true)
    }
    
}

