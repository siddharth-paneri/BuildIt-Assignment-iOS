//
//  ForecastViewController.swift
//  Weather
//
//  Created by Siddharth Paneri on 28/02/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import UIKit
import Charts
import AlamofireImage

class ForecastViewController: SuperViewController {

    @IBOutlet weak var view_ChartContainer: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var chartView: WeatherChartView!
    
    @IBOutlet weak var view_ListContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var forecastListViewModel = ForecastListViewModel()
    var cityViewModel: CityViewModel!

    //MARK:-
    override var shouldAutorotate : Bool {
        return forecastListViewModel.forecastViewType == .charts
    }
    
    
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Forecast"
        setupBarButton()
        setupTableView()
        chartView.themeColor = UIColor(hexString: Theme.Color.blue.rawValue)
        chartView.configure()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViewModelObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupOrientationObservers()
        self.showLoadingView(with: "Fetching data")
        forecastListViewModel.fetchForecasts(with: cityViewModel)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeViewModelObserves()
        removeOrientationObservers()
    }
    
    //MARK:-
    private func setupOrientationObservers() {
        // Subscribe for notifications
        NotificationCenter.default.addObserver(self, selector: #selector(orientationPortrait), name: NSNotification.Name(rawValue: NOTIF_ORIENTATION_CHANGED_TO_PORTRAIT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationLandscape), name: NSNotification.Name(rawValue: NOTIF_ORIENTATION_CHANGED_TO_LANDSCAPE), object: nil)
    }
    
    private func removeOrientationObservers(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIF_ORIENTATION_CHANGED_TO_PORTRAIT), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIF_ORIENTATION_CHANGED_TO_LANDSCAPE), object: nil)
    }
    
    private func setupViewModelObservers(){
        forecastListViewModel.didUpdate = { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.hideLoadingView()
            weakSelf.refreshUI()
        }
        forecastListViewModel.didFail = { [weak self] (weatherError) in
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
    private func removeViewModelObserves() {
        forecastListViewModel.didUpdate = nil
        forecastListViewModel.didFail = nil
    }
    
    /** Setup bar button for view type */
    private func setupBarButton() {
        if self.navigationItem.rightBarButtonItem == nil {
            
            let rightBarButtonItem = UIBarButtonItem(title: forecastListViewModel.switchToViewTypeTitle, style: .plain, target: self, action: #selector(viewTypeButtonTapped))
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    //MARK:- UI
    func refreshUI() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else {
                return
            }
            switch weakSelf.forecastListViewModel.forecastViewType {
            case .charts:
                weakSelf.view_ListContainer.isHidden = true
                weakSelf.view_ChartContainer.isHidden = false
                weakSelf.chartView.forecastListModel = weakSelf.forecastListViewModel
                weakSelf.chartView.unit = weakSelf.forecastListViewModel.chartUnit.rawValue
//                weakSelf.chartView.refreshChartData()
            case.list:
                weakSelf.view_ListContainer.isHidden = false
                weakSelf.view_ChartContainer.isHidden = true
                weakSelf.refreshTableView()
            }
            weakSelf.navigationItem.rightBarButtonItem?.title = weakSelf.forecastListViewModel.switchToViewTypeTitle
        }
    }
    
    private func refreshTableView() {
        tableView.reloadData()
    }
    
    //MARK:- Orientation based
    override func canRotate() -> Bool {
        return true
    }
    /** Notification observer for when orientation is changed to portrait mode */
    @objc func orientationPortrait() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    /** Notification observer for when orientation is changed to landscape mode */
    @objc func orientationLandscape() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- Actions
    @objc private func viewTypeButtonTapped() {
        forecastListViewModel.switchViewType()
    }
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        guard let segment = sender as? UISegmentedControl else {
            return
        }
        
        if segment == segmentedControl {
            if let forecastType = ForecastType(rawValue: segment.selectedSegmentIndex+1) {
                forecastListViewModel.forecastType = forecastType
            }
        }
        
    }
    

}

//MARK:- UITableViewDelegate & UITableViewDataSource {
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecastListViewModel.groupedCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastListViewModel.groupedViewModelCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let group = forecastListViewModel.group(at: section) else {
            return nil
        }
        // get date string for group
        return Config.shared.getDateString(timeInterval: TimeInterval(group))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell else {
            return UITableViewCell(frame: .zero)
        }
        guard let forecast = forecastListViewModel.groupedViewModel(at: indexPath.section, row: indexPath.row) else {
            return UITableViewCell(frame: .zero)
        }
        // configure cell
        cell.configureCell(forecast, type: forecastListViewModel.forecastType)
        return cell
    }
}


//MARK:-
class ForecastCell: UITableViewCell {
    
    @IBOutlet weak var label_Time: UILabel!
    @IBOutlet weak var image_Weather: UIImageView!
    @IBOutlet weak var label_Forecast: UILabel!
    
    /** Configure cell based on model and forecast type */
    func configureCell(_ model: ForecastViewModel, type: ForecastType) {
        label_Time.text = model.timeString
        let attributedString = NSMutableAttributedString()
        switch type {
        case .temperature:
            
            let attr1 = NSAttributedString(string: model.temperatureValue,
                                           attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor(hexString: Theme.Color.blue.rawValue)])
            attributedString.append(attr1)
            let minTemp = model.minTemperatureValue
            if !minTemp.isEmpty {
                let attr2 = NSAttributedString(string: "\n"+minTemp, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
                attributedString.append(attr2)
            }
            let maxTemp = model.maxTemperatureValue
            if !maxTemp.isEmpty {
                let attr2 = NSAttributedString(string: "/"+maxTemp, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
                attributedString.append(attr2)
            }
        case .wind:
            let speed = model.windSpeedValue
            if !speed.isEmpty {
                let attr1 = NSAttributedString(string: speed, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor(hexString: Theme.Color.blue.rawValue)])
                attributedString.append(attr1)
            }
            
        case .pressure:
            let pressure = model.pressureValue
            if !pressure.isEmpty {
                let attr1 = NSAttributedString(string: pressure, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor(hexString: Theme.Color.blue.rawValue)])
                attributedString.append(attr1)
            }
            
        }
        label_Forecast.attributedText = attributedString
        if let url = model.imageUrl {
            image_Weather.af_setImage(withURL: url)
        } else {
            image_Weather.image = nil
        }
        
    }
    
}
