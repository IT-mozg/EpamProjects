//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

struct CurrentWeather{
    let temperature: Double?
    let temperatureMax: Double?
    let humidity: Double?
    let pressure: Double?
    let icon: UIImage
    let time: TimeInterval
    let precipType: String
    
    let weatherTime: WeatherTime
    
    init?(json: [String: AnyObject], weatherTime: WeatherTime){
        guard let icon = json["icon"] as? String,
        let precipType = json["precipType"] as? String,
        let time = json["time"] as? Int64 else {return nil}
        
        self.temperature = json["temperature"] as? Double
        self.temperatureMax = json["temperatureMax"] as? Double
        self.humidity = json["humidity"] as? Double
        self.pressure = json["pressure"] as? Double
        self.icon = WeatherIconManager.init(rawValue: icon).image
        self.precipType = precipType
        self.time = TimeInterval(integerLiteral: time)
        self.weatherTime = weatherTime
    }
}

extension CurrentWeather{
    var timeString: String{
        let date = Date(timeIntervalSince1970: time)
        switch weatherTime {
        case .current:
            return "Today"
        case .minutely:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm"
            return dateFormatter.string(from: date)
        case .hourly:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:00 yyyy-MM-dd"
            return dateFormatter.string(from: date)
        case .daily:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let day = date.getDayOfWeek(){
                return "\(day) \(dateFormatter.string(from: date))"
            }
            return dateFormatter.string(from: date)
        }
    }
    
    var temperatureString: String{
        return "\(Int(temperature ?? temperatureMax ?? 0))˚F"
    }
    
    var humidityString: String{
        return "\(Int((humidity ?? 0) * 100))%"
    }
    
    var pressureString: String{
        return "\(Int(pressure ?? 700))mm"
    }
}

extension Date{
    func getDayOfWeek() -> String?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
