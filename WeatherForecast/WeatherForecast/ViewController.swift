//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Adrian Janakiewicz on 10.03.2020.
//  Copyright © 2020 Adrian Janakiewicz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var minTemperature: UILabel!
    
    @IBOutlet weak var maxTemperature: UILabel!
    
    @IBOutlet weak var windDirection: UILabel!
    
    @IBOutlet weak var windSpeed: UILabel!
    
    @IBOutlet weak var airPreassure: UILabel!
    
    @IBOutlet weak var precipitation: UILabel!
    
    @IBOutlet weak var previousButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
        
    var weatherData = [WeatherDay]()
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.previousButton.isEnabled = false
        self.loadWeatherData(latitude: "51.509865", longitude: "-0.118092", passData: { (results:[WeatherDay]?) in
            if let weatherData = results {
                self.weatherData = weatherData
                DispatchQueue.main.async {
                    self.showWeather(index: self.currentIndex)
                }
            }
        })
    }
    
    func loadWeatherData(latitude: String, longitude: String, passData: @escaping ([WeatherDay]?) -> ()) {
        
        let api = "https://api.darksky.net/forecast/9ac40a32eddecea5768fcbc6a53d73c8/"
        
        let url = api + "\(latitude),\(longitude)?exclude=currently,minutely,hourly&units=si"
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) {
            (data:Data?, response:URLResponse?, error:Error?) in
            
            var forecasts:[WeatherDay] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let forecast = json["daily"] as? [String:Any] {
                            if let forecastData = forecast["data"] as? [[String:Any]] {
                                for dataPoint in forecastData {
                                    if let weather = try? WeatherDay(dataPoint) {
                                        forecasts.append(weather)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                passData(forecasts)
            }
        }
        task.resume()
    }
    
    func showWeather(index: Int) {
        let weather = weatherData[index]
        minTemperature.text = String(weather.minTemperature) + "°C"
        maxTemperature.text = String(weather.maxTemperature) + "°C"
        windDirection.text = self.mapDegreeToDirection(degrees: weather.windDirection)
        windSpeed.text = String(weather.windSpeed) + "m/h"
        airPreassure.text = String(weather.airPreassure)
        precipitation.text = String(weather.precipitation)
        icon.image = UIImage(named: weather.icon)
        
        
        // setting date
        let date = Date(timeIntervalSince1970: weather.timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.date.text = dateFormatter.string(from: date)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        if(self.currentIndex < self.weatherData.count - 1) {
            self.currentIndex += 1
            self.showWeather(index: self.currentIndex)
            self.previousButton.isEnabled = true
        } else {
            self.nextButton.isEnabled = false
        }
    }
    
    @IBAction func previousClicked(_ sender: Any) {
        if(self.currentIndex > 0) {
            self.currentIndex -= 1
            self.showWeather(index: self.currentIndex)
            self.nextButton.isEnabled = true
        } else {
            self.previousButton.isEnabled = false
        }
    }
    
    func mapDegreeToDirection(degrees: Double) -> String {
        switch degrees {
        case 22.5...67.5:
            return "from NE to SW"
        case 67.5...112.5:
            return "from E to W"
        case 112.5...157.5:
            return "from SW to NE"
        case 157.5...202.5:
            return "from S to N"
        case 202.5...247.5:
            return "from SW to NE"
        case 247.5...292.5:
            return "from W to E"
        case 292.5...337.5:
            return "from NW to SE"
        default:
            return "from N to S"
        }
    }
    
}

