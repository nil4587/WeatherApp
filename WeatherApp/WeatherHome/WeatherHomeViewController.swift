//
//  WeatherHomeViewController.swift
//  WeatherApp
//
//  Created by Nileshkumar M. Prajapati on 08/07/22.
//

import UIKit
import CoreLocation

class WeatherHomeViewController: WeatherBaseViewController {

    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Properties Declaration
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var topImageView: UIImageView!
    @IBOutlet private weak var lblTemprature: UILabel!
    @IBOutlet private weak var lblWeatherType: UILabel!
    @IBOutlet private weak var toolBar: UIToolbar!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    private lazy var viewModel = WeatherHomeViewModel(delegate: self,
                                                      interactor: WeatherServicesInteractor())
    
    private var headerView: WeatherHomeHeaderView {
        let view = WeatherHomeHeaderView(frame: CGRect(x: 0.0, y: 0.0,
                                                       width: tableView.bounds.width, height: 60.0))
        view.set(minTemp: viewModel.minimumTemprature,
                 maxTemp: viewModel.maximumTemprature,
                 currentTemp: viewModel.currentTemprature,
                 color: viewModel.backgroundColor)
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.sectionHeaderTopPadding = 0.0
        tableView.backgroundView = activityIndicator
        tableView.register(UINib(nibName: "WeatherHomeTableViewCell", bundle: nil), forCellReuseIdentifier: "WeatherHomeTableViewCell")
        NotificationCenter.default.addObserver(self, selector: #selector(currentLocationUpdate(_:)),
                                               name: NSNotification.Name(rawValue: "CurrentLocationUpdate"),
                                               object: nil)
    }
    
    @objc func currentLocationUpdate(_ notification: Notification) {
        guard let location = notification.object as? CLLocation else { return }
        set(location: location)
    }
    
    private func set(location: CLLocation) {
        viewModel.set(currentLocation: location)
        showHUD()
        activityIndicator.startAnimating()
        viewModel.fetchCurrentWeatherInformation()
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Actions
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    @IBAction private func listTap(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToLocationSegue", sender: sender)
    }
    
    @IBAction private func refreshTap(_ sender: Any) {
        guard viewModel.isCurrentLocationAvailable else { return }
        showHUD()
        activityIndicator.startAnimating()
        viewModel.fetchCurrentWeatherInformation()
    }
    
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    // MARK: Navigation
    // MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "HomeToLocationSegue" {
            let destination = segue.destination as? LocationsViewController
            destination?.locationCoordinates = {(lat, lon) in
                guard let latitude = lat, let longitude = lon else { return }
                let location = CLLocation(latitude: latitude, longitude: longitude)
                DispatchQueue.main.async {
                    self.set(location: location)
                }
            }
        }
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: UITableView DataSource Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension WeatherHomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.forecastItems
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherHomeTableViewCell", for: indexPath) as? WeatherHomeTableViewCell else { return UITableViewCell() }
        let value = viewModel.weatherDetails(at: indexPath.row)
        cell.refreshView(with: value)
        return cell
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: UITableView Delegate Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension WeatherHomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// MARK: WeatherHomeViewModel Delegate Methods
// MARK: -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

extension WeatherHomeViewController: WeatherHomeViewModelDelegate {
    
    func currentWeatherInformationFetchedSuccessfully() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            self?.toolBar.tintColor = AppConstants.MainColor.white.rawValue
            self?.toolBar.barTintColor = self?.viewModel.backgroundColor
            self?.toolBar.backgroundColor = self?.viewModel.backgroundColor
            self?.view.backgroundColor = self?.viewModel.backgroundColor
            self?.topImageView.image = self?.viewModel.weatherBackgroundImage
            self?.lblTemprature.text = self?.viewModel.currentTemprature
            self?.lblWeatherType.text = self?.viewModel.weatherType
            self?.hideHUD()
            self?.viewModel.fetchWeatherForecast()
        }
    }
    
    func currentWeatherInformationFailure() {
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            self?.hideHUD()
        }
    }
    
    func weatherForecasInformationFetchedSuccessfully() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
            self?.hideHUD()
        }
    }
    
    func weatherForecasInformationFailure() {
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.stopAnimating()
            self?.tableView.reloadData()
            self?.hideHUD()
        }
    }
}
