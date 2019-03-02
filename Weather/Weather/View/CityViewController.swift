//
//  CityViewController.swift
//  Weather
//
//  Created by Siddharth Paneri on 27/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit

class CityViewController: SuperViewController {

    @IBOutlet weak var tableView: UITableView!
    private var selectedCityIndex: Int? = nil
    private var deleteIndexPath: IndexPath? = nil
    var citiesViewModel: CitiesViewModel = CitiesViewModel()
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup inital UI and components
        setupNavigationBar()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpViewModelObservers()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.refreshUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeViewModelObservers()
    }
    
    //MARK:-
    private func setUpViewModelObservers() {
        print(#function)
        citiesViewModel.didUpdate = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.refreshUI()
        }
        citiesViewModel.didFail = { [weak self] (weatherError) in
            guard let error = weatherError else {
                return
            }
            guard let weakSelf = self else {
                return
            }
            let tupple = error.tupple
            weakSelf.showError(withTitle: tupple.title, message: tupple.message)
        }
    }
    
    private func removeViewModelObservers() {
        citiesViewModel.didUpdate = nil
        citiesViewModel.didFail = nil
    }
    
    private func setupNavigationBar() {
        self.title = "Cities"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCity))
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    //MARK:- Fetch cities
    private func fetchData() {
        citiesViewModel.fetchCities()
    }
    
    //MARK:-
    private func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "CityForecast" {
                if let destinationVC = segue.destination as? ForecastViewController {
                    if let index = selectedCityIndex {
                        if citiesViewModel.count > index {
                            destinationVC.cityViewModel = citiesViewModel.viewModel(at: index)
                        }
                    }
                }
            }
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CityForecast" {
            if let index = selectedCityIndex {
                if citiesViewModel.count > index {
                    guard let _ = citiesViewModel.viewModel(at: index) else {
                        return false
                    }
                }
            }
        }
        return true
    }
 

    //MARK:- Actions
    
    @objc private func addCity() {
        performSegue(withIdentifier: "FindCity", sender: self)
    }
    
    /** confirm deletion of the city */
    func confirmDelete(_ city: CityViewModel){
        let alertController = UIAlertController(title: "Delete city", message: "Are you sure you want to delete \(city.name)", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteCity)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteCity)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    /** handle delete action */
    func handleDeleteCity(alertAction: UIAlertAction) {
        if let indexPath = deleteIndexPath {
            guard let city = citiesViewModel.viewModel(at: indexPath.row) else {
                return
            }
            tableView.beginUpdates()
            _ = citiesViewModel.remove(city: city)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    /** handle cancel action */
    func cancelDeleteCity(alertAction: UIAlertAction) {
        deleteIndexPath = nil
    }
}

//MARK:- UITableViewDelegate & UITableViewDataSource
extension CityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if citiesViewModel.count > indexPath.row {
            guard let city = citiesViewModel.viewModel(at: indexPath.row) else {
                return UITableViewCell(frame: .zero)
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
            // set city name
            cell.textLabel?.text = city.name
            return cell
        }
        return UITableViewCell(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCityIndex = indexPath.row
        performSegue(withIdentifier: "CityForecast", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // swipe to delete
            guard let city = citiesViewModel.viewModel(at: indexPath.row) else {
                return
            }
            deleteIndexPath = indexPath
            confirmDelete(city)
        }
    }
    
}
