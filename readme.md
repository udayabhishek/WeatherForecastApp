## WeatherForecastApp

This app displays 5 days weather forecast using openweathermap.org API.

### Requirements

iOS 10.0 and Swift 3.2 are required.

### Library used

Alamofire - for fetching JSON data

https://github.com/Alamofire/Alamofire

SwiftyJSON - for parsing JSON

https://github.com/SwiftyJSON/SwiftyJSON how to use:

In terminal to navigate to your project folder
```
  gem install cocoapods
  sudo gem install cocoapods
  pod init
  //open Podfile and add and save podfile
  pod 'Alamofire', '~> 4.4'
  pod 'SwiftyJSON'
  pod install
  
  ```
  
##### To fetch JSON

```
        let apiKey = "a06d4ebad91f121ad6e5c698711ea0d3"
        let URL = "http://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&units=\(units)&APPID=\(apiKey)"
        Alamofire.request(URL).responseJSON
        {
            response in
            switch response.result
            {
                case .success(let value):
                    let json = JSON(value)

                  
                case .failure(let error):
                    print(error)
            }  
        }
 ```
 
 #### JSON Structure 
 
 ![Alt text](https://github.com/udayabhishek/WeatherForecastApp/blob/master/JSON_Str1.png)
 ![Alt text](https://github.com/udayabhishek/WeatherForecastApp/blob/master/JSON_Str2.png)
 ![Alt text](https://github.com/udayabhishek/WeatherForecastApp/blob/master/JSON_Str3.png)
 
 
 ##### Parsing code block
 ``` Swift
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

 ```
 ### Screenshot of the app screen
 
 
 ![Alt text](https://github.com/udayabhishek/WeatherForecastApp/blob/master/SS1.png)
 ![Alt text](https://github.com/udayabhishek/WeatherForecastApp/blob/master/SS3.png)
 ![Alt text](https://github.com/udayabhishek/WeatherForecastApp/blob/master/SS2.png)
 
        
