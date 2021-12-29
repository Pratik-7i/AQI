//
//  AQIListViewController.swift
//  AQI
//
//  Created by Pratik on 11/12/21.
//

import UIKit
import Starscream

class AQIListViewController: UIViewController
{
    @IBOutlet var errorView        : UIView!
    @IBOutlet var errorLabel       : UILabel!
    @IBOutlet var aqiListTableView : UITableView!

    private var backgroundbObserver: NSObjectProtocol?
    private var foregroundObserver: NSObjectProtocol?

    lazy var viewModel : AQIListViewModel = {
        let viewModel = AQIListViewModel()
        viewModel.socketDelegate = self
        viewModel.listDelegate = self
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupControls()
        self.addObservers()
        self.viewModel.startObservingAQIData()
    }
    
    func setupControls() {
        self.title = "Cities"
        self.aqiListTableView.registerCellNib(AQIListTableViewCell.self)
    }
    
    @IBAction func retryButtonTapped(_ sender: UIButton) {
        self.viewModel.connectSocket()
    }
    
    // Add observer to reconnect socket after Application comes from background mode.
    func addObservers () {
        self.backgroundbObserver = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.viewModel.disconnectSocket()
        }
        self.foregroundObserver = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            self.viewModel.connectSocket()
        }
    }
    
    deinit {
        if let backgroundbObserver = self.backgroundbObserver {
            NotificationCenter.default.removeObserver(backgroundbObserver)
        }
        if let foregroundObserver = self.foregroundObserver {
            NotificationCenter.default.removeObserver(foregroundObserver)
        }
    }
}

extension AQIListViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.cityAQIArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AQIListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AQIListTableViewCell", for: indexPath) as! AQIListTableViewCell
        let cityModel = self.viewModel.cityAQIArray[indexPath.row]
        cell.load(cityModel)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = self.storyboard?.instantiateViewController(withIdentifier: "AQIChartViewController") as? AQIChartViewController else { return }
        let selectedCity = self.viewModel.cityAQIArray[indexPath.row]
        controller.viewModel.cityModel = selectedCity
        self.viewModel.selectedCityModel = selectedCity
        self.viewModel.chartDelegate = controller.viewModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AQIListViewController: AQIListDelegate {
    func didUpdateAQIData() {
        self.aqiListTableView.reloadData()
    }
}

extension AQIListViewController: SocketDelegate
{
    func socketStatuDidUpdate(isConnected: Bool, error: String?) {
        self.aqiListTableView.isHidden = !isConnected
        self.errorView.isHidden = isConnected
        self.errorLabel.text = error
    }
}
