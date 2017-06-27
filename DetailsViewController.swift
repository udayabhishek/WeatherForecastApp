//
//  DetailsViewController.swift
//  WeatherForecast
//
//  Created by Uday Kumar Abhishek - (Digital) on 24/06/17.
//  Copyright © 2017 Uday Kumar Abhishek - (Digital). All rights reserved.
//

import Foundation
import UIKit
var forecastDetails = [[String: Any]]()
var weatherValueArray = [Int]()
var weatherNameArray = [String]()

class DetailsViewController : UIViewController, UITableViewDataSource {
    @IBOutlet weak var labelHumidity: UILabel!
    @IBOutlet weak var labelPressure: UILabel!
    @IBOutlet weak var labelWindSpeed: UILabel!
    @IBOutlet weak var labelWindDegree: UILabel!
    @IBOutlet weak var tableViewTeperatureDetails: UITableView!

    
    let baseURLForIcon = "http://openweathermap.org/img/w/"
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "backgroundImage.png")!)
        updateUI()
    }
    
    
    func updateUI(){
        let valueHumidity =  String(describing: forecastDetails[0]["humidity"]!)
        let measurementHumidity = " %"
        labelHumidity.text = valueHumidity + measurementHumidity
        
        let valuePressure =  String(describing: forecastDetails[0]["pressure"]!)
        let measurementPressure = " hPa"
        labelPressure.text = valuePressure + measurementPressure
        
        let valueWindSpeed =  String(describing: forecastDetails[0]["windSpeed"]!)
        let measurementWindSpeed = " m/s"
        labelWindSpeed.text = valueWindSpeed + measurementWindSpeed
        
        let valueWindDegree =  String(describing: forecastDetails[0]["windDegree"]!)
        let measurementWindDegree = " °"
        labelWindDegree.text = valueWindDegree + measurementWindDegree
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowNumber = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTemperatureDetails", for: indexPath) as! TemperatureDetailsCell
        let iconName = String(describing: forecastDetails[rowNumber]["iconName"]!)
        let url = "\(baseURLForIcon)\(iconName).png"
        cell.imageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
        cell.labelTime.text = String(describing: forecastDetails[rowNumber]["time"]!)
        cell.labelTemprature.text = String(describing: forecastDetails[rowNumber]["temp"]!)
        cell.labelTemperatureMax.text = String(describing: forecastDetails[rowNumber]["temp_max"]!)
        cell.labelTempratureMin.text = String(describing: forecastDetails[rowNumber]["temp_min"]!)
        return cell
    }
}
