//
//  LocationsViewController.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 11/07/22.
//

import UIKit

class LocationsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var locationCoordinates: (_ latitude: Double?, _ longitude: Double?) -> Void = {(_,_) in}
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Properties Declaration
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    lazy private var viewModel = LocationsViewModel(delegate: self,
                                                    interactor: LocationServicesInteractor())
    var searchController: UISearchController?
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: View Lifecycle
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController?.delegate = self
        searchController?.searchResultsUpdater = self
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "Search for City, State, Country"
        searchController?.definesPresentationContext = false
        self.navigationItem.searchController = searchController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        WebServiceManager.webServiceHelper.stopTask()
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: UISearchResultsUpdating Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension LocationsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmedString else{ return }
        viewModel.isSearching = true
        #if DEBUG
            print(query)
        #endif
        viewModel.fetchLocation(using: query)
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: UISearchController Delegate Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension LocationsViewController: UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        WebServiceManager.webServiceHelper.stopTask()
        viewModel.isSearching = false
        self.clearSearchResultAndLoadSavedLocations()
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: UITableView DataSource Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension LocationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        let values = viewModel.locationDetails(at: indexPath.row)
        cell?.textLabel?.text = values?.title
        cell?.detailTextLabel?.text = values?.subTitle
        return cell!
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: UITableView Delegate Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension LocationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if viewModel.isSearching {
            let values = viewModel.saveLocationAt(index: indexPath.row)
            self.locationCoordinates(values?.latitude, values?.longitude)
        } else {
            let values = viewModel.locationAt(index: indexPath.row)
            self.locationCoordinates(values?.latitude, values?.longitude)
        }
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    private func dismissSearchController() {
        searchController?.dismiss(animated: true) {
            self.clearSearchResultAndLoadSavedLocations()
        }
    }
    
    private func clearSearchResultAndLoadSavedLocations() {
        self.viewModel.clearSearchResult()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.searchController?.searchBar.resignFirstResponder()
            self.searchController?.searchBar.text = nil
            self.tableView.reloadData()
        })
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: LocationsViewModel Delegate Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension LocationsViewController: LocationsViewModelDelegate {
    
    func locationsRetrivedSuccessfully() {
        DispatchQueue.main.async {[weak self] in
            guard let mainSelf = self else { return }
            mainSelf.tableView.reloadData()
        }
    }
    
    func locationsRetrivalFailed() {
    }
}
