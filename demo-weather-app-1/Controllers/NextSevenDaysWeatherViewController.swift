//
//  WeeklyViewController.swift
//  demo-weather-app-1
//
//  Created by Abdullah Mohammad Daihan on 14/7/21.
//

import UIKit
import CoreLocation

class NextSevenDaysWeatherViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var weeklyWeatherData: NextSevenDaysWeatherData?
    var apiCallingStruct = ApiCallingStruct()
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        apiCallingStruct.weatherDelegate = self
        
        if let lat = latitude , let lon = longitude{
            apiCallingStruct.callApi(latitude: lat, longitude: lon, isWeeklyForcast: true)
        }
    }
}

//MARK:- ApiCallingStructDelegate
extension NextSevenDaysWeatherViewController: ApiCallingStructDelegate{
    func updateUI(_ apiCallingStruct: ApiCallingStruct,weatherData:Codable) {
        self.weeklyWeatherData = weatherData as? NextSevenDaysWeatherData
        print("Updated UI in \(#file):\(#line)")
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK:- UITableViewDataSource
extension NextSevenDaysWeatherViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ( weeklyWeatherData?.daily.count ?? 1 ) - 1
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherCellIdentifier, for: indexPath) as! WeeklyWeatherCell
        
        if let dailyWeather = weeklyWeatherData?.daily[indexPath.row + 1]{
            cell.updateCell(dailyWeather: dailyWeather, dayOfTheWeek: indexPath.row + 1)
        }
        cell.backgroundColor = UIColor(named: Constants.appBackGroundColor)
        
        return cell
    }
}


extension NextSevenDaysWeatherViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    let detailsOfDailyWeatherVC =  storyboard?.instantiateViewController(withIdentifier: Constants.detailsOfDailyWeatherIdentifier) as! DetailsOfDailyWeatherViewController
      // passing data to next vc [S]
        let weeklyWeatherDataDaily = weeklyWeatherData?.daily[indexPath.row + 1]
        detailsOfDailyWeatherVC.dailyWeather = weeklyWeatherDataDaily
        if let theDate = weeklyWeatherDataDaily?.dt{
            detailsOfDailyWeatherVC.theDate = theDate.getDate(atDDMMMformat: true)
        }
     // passing data to next vc [E]
        navigationController?.pushViewController(detailsOfDailyWeatherVC, animated: true)
    }
}