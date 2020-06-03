//
//  WeatherDay.swift
//  WeatherForecast
//
//  Created by Adrian Janakiewicz on 10/03/2020.
//  Copyright © 2020 Adrian Janakiewicz. All rights reserved.
//

import Foundation

class WeatherDay {
    let weatherType: String
    let minTemperature: Double
    let maxTemperature: Double
    let windDirection: Double
    let windSpeed: Double
    let airPreassure: Double
    let precipitation: Double
    let icon:String
    let timeStamp:Double

    init(_ json:[String:Any]){
       self.weatherType = json["summary"] as! String
       self.maxTemperature = json["temperatureMax"] as! Double
       self.minTemperature = json["temperatureMin"] as! Double
       self.windSpeed = json["windSpeed"] as! Double
       self.windDirection = json["windBearing"] as! Double
       self.precipitation = json["humidity"] as! Double
       self.airPreassure = json["pressure"] as! Double
       self.icon = json["icon"] as! String
       self.timeStamp = json["time"] as! Double
    }
    
}
