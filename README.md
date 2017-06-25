# WeatherForecastApp
*This app displays 5 days weather forecast using openweathermap.org API.*

### Requirements
iOS 10.0 and Swift 3.2 are required.

### Library used

#### Alamofire - for fetching JSON data
https://github.com/Alamofire/Alamofire

#### SwiftyJSON - for parsing JSON
https://github.com/SwiftyJSON/SwiftyJSON
how to use:

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

#### To fetch JSON
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


