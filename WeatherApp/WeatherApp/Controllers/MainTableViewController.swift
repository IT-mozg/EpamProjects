//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Vlad on 6/4/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    private var cells = [Presentation]()
    private var coords: Coordinates!
    private var hourlyWeather = [CurrentWeather]()
    private var dailyWeather = [CurrentWeather]()
    
    lazy var weatherManager = APIWeatherManager(apiKey: "808589ed03cd42e439b180e2c412b012")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coords = Coordinates(latitude: 49.236046, longitude: 28.451438)
        refreshWeather()
        setupCells()
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func refreshWeather(){
        weatherManager.fetchWeather(with: coords, time: .hourly) { (results) in
            for result in results{
                switch result{
                case .success(let weather):
                    self.hourlyWeather.append(weather)
                case .failure(let error as NSError):
                    print(error.description)
                @unknown default:
                    break
                }
            }
            self.cells[1] = Presentation(cellType: .hourlyWeather, dataType: .weather(self.hourlyWeather))
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.reloadData()
                self.tableView.endUpdates()
            }
        }
        weatherManager.fetchWeather(with: coords, time: .daily) { (results) in
            for result in results{
                switch result{
                case .success(let weather):
                    self.dailyWeather.append(weather)
                case .failure(let error as NSError):
                    print(error.description)
                @unknown default:
                    break
                }
            }
            self.cells[2] = Presentation(cellType: .dailyWeather, dataType: .weather(self.dailyWeather))
            let indexPath  = IndexPath(row: 2, section: 0)
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.tableView.endUpdates()
            }
        }
    }
    
    private func setupCells(){
        cells.append(Presentation(cellType: .cityName, dataType: .text("Vinnitsa")))
        cells.append(Presentation(cellType: .hourlyWeather, dataType: .weather(hourlyWeather)))
        cells.append(Presentation(cellType: .dailyWeather, dataType: .weather(dailyWeather)))
        cells.append(Presentation(cellType: .refresh, dataType: .text("Refresh")))
    }
}

//MARK: UITableViewControllerDataSource
extension MainTableViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let present = cells[indexPath.row]
        switch present.cellType {
        case .cityName, .refresh:
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! TitleTableViewCell
            cell.presentation = present
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weatherInfoCell") as! CollectionTableViewCell
            cell.presentation = present
            return cell
        }
    }
}

//MARK: UITableViewDelegate
extension MainTableViewController{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = cells[indexPath.row].cellType
        switch cellType {
        case .cityName:
            return 70
        case .refresh:
            return 70
        default:
            return 230
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = cells[indexPath.row].cellType
        switch cellType {
        case .refresh:
            self.tableView.reloadData()
        default:
            break
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
