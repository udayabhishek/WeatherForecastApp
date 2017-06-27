//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Uday Kumar Abhishek - (Digital) on 16/06/17.
//  Copyright © 2017 Uday Kumar Abhishek - (Digital). All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate{
    
    @IBOutlet weak var viewWeather: UIView!
    @IBOutlet weak var cityNameSearchTextField: UITextField!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewWeatherForecast: UITableView!
   
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var tempDict : [String: Any] = [:]
    var day0 = [[String: Any]]()//Today
    var day1 = [[String: Any]]()
    var day2 = [[String: Any]]()
    var day3 = [[String: Any]]()
    var day4 = [[String: Any]]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        hideViews()
        view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "backgroundImage.png")!)
        activityIndicator.isHidden = true
    }
    
//    MARK: - User Input
    @IBAction func SearchButton(_ sender: Any) {
                day0 = [[String: Any]]()//Today
                day1 = [[String: Any]]()
                day2 = [[String: Any]]()
                day3 = [[String: Any]]()
                day4 = [[String: Any]]()

        let cityName = cityNameSearchTextField.text
        if cityName != nil{
            //          metric is as default
            let feed = getJSONData(cityName: cityName!, units: "metric")
            if feed == true{
            }else{
                alert(title: "oops", message: "You missed the city name")
            }
        }
        else{
            alert(title: "oops", message: "You missed the city name")
        }
    }
    
    
    @IBAction func segmentToggleBetweenCAndF(_ sender: UISegmentedControl) {
        day0 = [[String: Any]]()//Today
        day1 = [[String: Any]]()
        day2 = [[String: Any]]()
        day3 = [[String: Any]]()
        day4 = [[String: Any]]()
        let cityName = cityNameSearchTextField.text!
        if cityName.isEmpty{
            hideViews()
            alert(title: "Oops", message: "You missed the city name")
        }else{
            switch sender.selectedSegmentIndex{
            case 0:
                _ = getJSONData(cityName: cityName, units: "metric")
            case 1:
                _ = getJSONData(cityName: cityName, units: "imperial")
            default:
                break
            }
        }
    }
    
//  MARK: - Update User Interface
    func addDetailsOntoUI() {
        showViews()
        let degree = "°"
        let temperature = String(describing: self.day0[0]["temp"]!)
        labelTemperature.text = temperature + degree
        labelCityName.text = String(describing: self.day0[0]["cityName"]!)
        tableViewWeatherForecast.reloadData()
    }
  
    func getJSONData(cityName:String, units:String)->Bool{
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        var status = true
//        http://api.openweathermap.org/data/2.5/forecast?q=London,us&mode=json&APPID=a06d4ebad91f121ad6e5c698711ea0d3
//        for temperature in Centigrade use &units=metric
//        for temperature in Fahrenheit use &units=imperial
        let apiKey = "a06d4ebad91f121ad6e5c698711ea0d3"
        let URL = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&units=\(units)&APPID=\(apiKey)"
        Alamofire.request(URL).responseJSON
        {
            response in
            self.activityIndicator.stopAnimating()
            switch response.result
            {
                case .success(let value):

                    let json = JSON(value)
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let currentDate = String(describing: dateFormatter.string(from: date))
                    let statusCode = json["cod"].string!
                    if statusCode == "200"{
                        let dateList = json["list"].array
                        var dateString:String
                        var dateArray:[String]
                        var counter = 0
                        for item in dateList!{
//                        data format
//                        item["main"]["temp_min"]
//                        item["main"]["temp_max"]
//                        item["main"]["temp"]
//                        item["dt_txt"]
//                        item["dt"]
//                        item["main"]["pressure"]
//                        item["main"]["humidity"]
//                        item["wind"]["speed"]
                            
                            let str = item["dt_txt"].string
                            dateString = String(describing: str!)
                            dateArray = dateString.components(separatedBy: " ")
                            let dateFromString = dateArray[0]
                            
                            self.tempDict["cityName"] = json["city"]["name"]
                            self.tempDict["country"] = json["city"]["country"]
                           
                            if currentDate == dateFromString{
//                            day0: Today
                                
                                self.tempDict["temp"] = item["main"]["temp"].int! //Temperature
                                self.tempDict["temp_max"] = item["main"]["temp_max"].int! //Maximum Temperature
                                self.tempDict["temp_min"] = item["main"]["temp_min"].int! //Minimum Temperature
                                self.tempDict["dayName"] = self.getDayOfWeek(dateArray[0]) //to get name of the day
                                self.tempDict["date"] = dateArray[0] //Takes only date
                                self.tempDict["time"] = dateArray[1] // Taked onlt time
                                self.tempDict["iconName"] =  item["weather"][0]["icon"] //Weather icon
                                self.tempDict["weatherType"] = item["weather"][0]["main"] //Weather type: cloudy, rain, clear etc.
                                self.tempDict["pressure"] = item["main"]["pressure"].int!//Presssure
                                self.tempDict["humidity"] = item["main"]["humidity"].int!//Humidity
                                self.tempDict["windSpeed"] = item["wind"]["speed"].int!//Speed of the wind
                                self.tempDict["windDegree"] = item["wind"]["deg"].int!//Wind  degree
                                self.day0.append(self.tempDict) //appending all temporary dictionary elements into the array of dictionary
                            }
                            else{
//                            Other days
                                self.tempDict["temp"] = item["main"]["temp"].int!
                                self.tempDict["temp_max"] = item["main"]["temp_max"].int!
                                self.tempDict["temp_min"] = item["main"]["temp_min"].int!
                                self.tempDict["date"] = dateArray[0]
                                self.tempDict["time"] = dateArray[1]
                                self.tempDict["dayName"] = self.getDayOfWeek(dateArray[0])
                                self.tempDict["iconName"] =  item["weather"][0]["icon"]
                                self.tempDict["weatherType"] = item["weather"][0]["main"]
                                self.tempDict["pressure"] = item["main"]["pressure"].int!
                                self.tempDict["humidity"] = item["main"]["humidity"].int!
                                self.tempDict["windSpeed"] = item["wind"]["speed"].int!
                                self.tempDict["windDegree"] = item["wind"]["deg"].int!
//                            day1: Tomorrow, temperature data is for each 3 hours, so for one day 24/3 = 8times
                                if counter >= 0 && counter < 8 {
                                    self.day1.append(self.tempDict)
                                    counter += 1
                                }
//                            day 2
                                else if counter >= 8 && counter < 16{
                                    self.day2.append(self.tempDict)
                                    counter += 1
                                }
//                            day 3
                                else if counter >= 16 && counter < 24{
                                    self.day3.append(self.tempDict)
                                    counter += 1
                                }
//                            day 4
                                else if counter >= 24 && counter < 32{
                                    self.day4.append(self.tempDict)
                                    counter += 1
                                }
                            }
                        }
                        self.addDetailsOntoUI()
                    }else{
                            self.hideViews()
                            self.alert(title: "City Not Found", message: "")
                    }
                case .failure(let error):
                    self.hideViews()
                    status = false
                    print(error)
                    self.alert(title: "Oops", message: "City Not Found")
            }
        }
        return status
    }
    
// MARK: - UITableViewDelegates Function
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.day0.count <= 1 {
            return 0
        }
        else{
//            For five days weather
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        index 0 is being used for picking top element from each day's array and displaying in the table row
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let baseURLForIcon = "http://openweathermap.org/img/w/"
//        here index 0 is for
        if indexPath.row == 0{
            let iconName = String(describing: day0[0]["iconName"]!)
            let url = "\(baseURLForIcon)\(iconName).png"
            cell.imageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
//            cell.labelDayName.text = day0[0]["dayName"]! as? String
            cell.labelDayName.text = "Today"
            cell.labelWeatherType.text = String(describing: day0[0]["weatherType"]!)
            cell.labelTemperatureMax.text = String(describing: self.day0[0]["temp_max"]!)
            cell.labelTemperatureMin.text = String(describing: self.day0[0]["temp_min"]!)
        }

        if indexPath.row == 1{
            let iconName = String(describing: day1[0]["iconName"]!)
            let url = "\(baseURLForIcon)\(iconName).png"
             cell.imageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
//            cell.labelDayName.text = day1[0]["dayName"]! as? String
            cell.labelDayName.text = "Tomorrow"
            cell.labelWeatherType.text = String(describing: day1[0]["weatherType"]!)
            cell.labelTemperatureMax.text = String(describing: self.day1[0]["temp_max"]!)
            cell.labelTemperatureMin.text = String(describing: self.day1[0]["temp_min"]!)
        }
        else if indexPath.row == 2{
            let iconName = String(describing: day2[0]["iconName"]!)
            let url = "\(baseURLForIcon)\(iconName).png"
            cell.imageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.labelDayName.text = day2[0]["dayName"]! as? String
            cell.labelWeatherType.text = String(describing: day2[0]["weatherType"]!)
            cell.labelTemperatureMax.text = String(describing: self.day2[0]["temp_max"]!)
            cell.labelTemperatureMin.text = String(describing: self.day2[0]["temp_min"]!)
        }
        else if indexPath.row == 3{
            let iconName = String(describing: day3[0]["iconName"]!)
            let url = "\(baseURLForIcon)\(iconName).png"
            cell.imageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.labelDayName.text = day3[0]["dayName"]! as? String
            cell.labelWeatherType.text = String(describing: day3[0]["weatherType"]!)
            cell.labelTemperatureMax.text = String(describing: self.day3[0]["temp_max"]!)
            cell.labelTemperatureMin.text = String(describing: self.day3[0]["temp_min"]!)
        }
        else if indexPath.row == 4{
            let iconName = String(describing: day4[0]["iconName"]!)
            let url = "\(baseURLForIcon)\(iconName).png"
            cell.imageView?.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
            cell.labelDayName.text = day4[0]["dayName"]! as? String
            cell.labelWeatherType.text = String(describing: day4[0]["weatherType"]!)
            cell.labelTemperatureMax.text = String(describing: self.day4[0]["temp_max"]!)
            cell.labelTemperatureMin.text = String(describing: self.day4[0]["temp_min"]!)
        }
        return cell
    }
    
//    MARK: - UITableViewDataSource method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        forecastDetails = [[String:Any]]()
        let rowNumber = indexPath.row
        
        if rowNumber == 0{
            forecastDetails = day0
        }
        else if rowNumber == 1{
            forecastDetails = day1
        }
        else if rowNumber == 2{
            forecastDetails = day2
        }
        else if rowNumber == 3{
            forecastDetails = day3
        }
        else if rowNumber == 4{
            forecastDetails = day4
        }
        performSegue(withIdentifier: "segueDetailsView", sender: self)
    }
    
//    MARK: - Helper Functions
    
    func getDayOfWeek(_ today:String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednessday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return ""
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showViews() {
        self.viewWeather.isHidden = false
        self.tableViewWeatherForecast.isHidden = false
    }
    
    func hideViews() {
        self.viewWeather.isHidden = true
        self.tableViewWeatherForecast.isHidden = true
    }
    
//    MARK - UITextFieldDelegate Function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    

}

