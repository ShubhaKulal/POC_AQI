//
//  AirQualityListTableViewController.swift
//  AirQualityMonitoring
//
//  Created by techjini on 01/12/21.
//

import UIKit

class AQIListViewController: UITableViewController {
    
    let viewModel = AQIBaseViewModel(with:[Const.city.delhi,Const.city.mumbai, Const.city.kolkata,Const.city.bengaluru,Const.city.chennai, Const.city.hyderabad,Const.city.pune])
    
    // MARK: - View lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.startSocketConnection()
        viewModel.delegate = self
        self.title = Const.airQualityIndex
        self.tableView.estimatedRowHeight = 200.0
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.stopScoketConnection()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.defaultCitiesList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aqiCell : AQITableViewCell = tableView.dequeueReusableCell(withIdentifier: "AQITableViewCell", for: indexPath) as! AQITableViewCell
        let aqiData = viewModel.defaultCitiesList[indexPath.row]
        aqiCell.configurView(with: aqiData)
        aqiCell.selectionStyle = .none
        // Configure the cell...
        return aqiCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 120;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let element = self.viewModel.defaultCitiesList[indexPath.row]
        let graphViewModel = AQIBaseViewModel(with: [element.city])
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : AQIDetailViewController = storyboard.instantiateViewController(withIdentifier: "AQMDetailViewController") as! AQIDetailViewController
        viewController.viewModel = graphViewModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK:- View modelDelegate

extension AQIListViewController: ViewModelDelegate {
    func viewModelDidUpdate() {
        tableView.reloadData()
    }
}


