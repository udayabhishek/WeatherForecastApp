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
    @IBOutlet weak var cityNameSearchTextField: UITextField!
    @IBOutlet weak var labelCityName: UILabel!
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewWeatherForecast: UITableView!
    var day0 = [[String: Any]]()//Today
    var day1 = [[String: Any]]()
    var day2 = [[String: Any]]()
    var day3 = [[String: Any]]()
    var day4 = [[String: Any]]()
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
    
    @IBAction func SearchButton(_ sender: Any) {
//                day0 = [[:]]//Today
//                day1 = [[:]]
//                day2 = [[:]]
//                day3 = [[:]]
//                day4 = [[:]]
        let cityName = cityNameSearchTextField.text
        if cityName != nil{
            print(cityName!)
            labelCityName.text = cityName!
//            metric is as default
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
//        day0 = [[:]]//Today
//        day1 = [[:]]
//        day2 = [[:]]
//        day3 = [[:]]
//        day4 = [[:]]
        let cityName = cityNameSearchTextField.text!
        if cityName.isEmpty{
            alert(title: "Oops", message: "You missed the city name")
        }else{
            switch sender.selectedSegmentIndex{
            case 0:
                print("C")
                _ = getJSONData(cityName: cityName, units: "metric")
            case 1:
                print("F")
                _ = getJSONData(cityName: cityName, units: "imperial")
            default:
                break
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "backgr.png")!)
        activityIndicator.isHidden = true
    }
    
    func addDetailsOntoUI() {
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
        print(URL)
        Alamofire.request(URL).responseJSON
        {
            response in
            self.activityIndicator.stopAnimating()
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    print(dateFormatter.string(from: date))
                    let currentDate = String(describing: dateFormatter.string(from: date))
                    print(currentDate)
                    let statusCode = json["cod"].string!
                    if statusCode == "200"{
                        let dateList = json["list"].array
                        print(dateList ?? "")
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
                            print(dateFromString)
                            var tempDict : [String: Any] = [:]
                            tempDict["cityName"] = json["city"]["name"]
                            tempDict["country"] = json["city"]["country"]
                            if currentDate == dateFromString{
//                            day0: Today
                                tempDict["temp"] = item["main"]["temp"].int! //Temperature
                                tempDict["temp_max"] = item["main"]["temp_max"].int! //Maximum Temperature
                                tempDict["temp_min"] = item["main"]["temp_min"].int! //Minimum Temperature
                                tempDict["dayName"] = self.getDayOfWeek(dateArray[0]) //to get name of the day
                                tempDict["date"] = dateArray[0] //Takes only date
                                tempDict["time"] = dateArray[1] // Taked onlt time
                                tempDict["iconName"] =  item["weather"][0]["icon"] //Weather icon
                                tempDict["weatherType"] = item["weather"][0]["main"] //Weather type: cloudy, rain, clear etc.
                                tempDict["pressure"] = item["main"]["pressure"].int!//Presssure
                                tempDict["humidity"] = item["main"]["humidity"].int!//Humidity
                                tempDict["windSpeed"] = item["wind"]["speed"].int!//Speed of the wind
                                tempDict["windDegree"] = item["wind"]["deg"].int!//Wind  degree
                                self.day0.append(tempDict) //appending all temporary dictionary elements into the array of dictionary
                            }
                            else{
//                            Other days
                                tempDict["temp"] = item["main"]["temp"].int!
                                tempDict["temp_max"] = item["main"]["temp_max"].int!
                                tempDict["temp_min"] = item["main"]["temp_min"].int!
                                tempDict["date"] = dateArray[0]
                                tempDict["time"] = dateArray[1]
                                tempDict["dayName"] = self.getDayOfWeek(dateArray[0])
                                tempDict["iconName"] =  item["weather"][0]["icon"]
                                tempDict["weatherType"] = item["weather"][0]["main"]
                                tempDict["pressure"] = item["main"]["pressure"].int!
                                tempDict["humidity"] = item["main"]["humidity"].int!
                                tempDict["windSpeed"] = item["wind"]["speed"].int!
                                tempDict["windDegree"] = item["wind"]["deg"].int!
//                            day1: Tomorrow, temperature data is for each 3 hours, so for one day 24/3 = 8times
                                if counter >= 0 && counter < 8 {
                                    self.day1.append(tempDict)
                                    counter += 1
                                }
//                            day 2
                                else if counter >= 8 && counter < 16{
                                    self.day2.append(tempDict)
                                    counter += 1
                                }
//                            day 3
                                else if counter >= 16 && counter < 24{
                                    self.day3.append(tempDict)
                                    counter += 1
                                }
//                            day 4
                                else if counter >= 24 && counter < 32{
                                    self.day4.append(tempDict)
                                    counter += 1
                                }
                            }
                        }
                        self.addDetailsOntoUI()
                    }else{
                            self.alert(title: "City Not Found", message: "")
                    }
                case .failure(let error):
                    status = false
                    self.alert(title: "Oops, somthing went wrong:", message: "Reason: \(error)")
            }
        }
        return status
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        forecastDetails = [[:]]
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
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
//        
//        if (segue.identifier == "segueDetailsView") {
//            // initialize new view controller and cast it as your view controller
//            var viewController = segue.destination as! DetailsViewController
//            // your new view controller should have property that will store passed value
////            viewController.passedValue = valueToPass
//        }
//    }
}

