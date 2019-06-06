//
//  WeatherIconManager.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

enum WeatherIconManager : String{
    case clearDay = "clear-day"
    case clearNight = "clear-night"
    case cloudy = "cloudy"
    case hail = "hail"
    case partlyCloudyDay = "partly-cloudy-day"
    case partlyCloudyNight = "partly-cloudy-night"
    case rain = "rain"
    case sleet = "sleet"
    case wind = "wind"
    case snow = "snow"
    case thunderstorm = "thunderstorm"
    case tornado = "tornado"
    case unpredicted = "unpredicted-icon"
    
    init(rawValue: String){
        switch rawValue {
        case "clear-day":
            self = .clearDay
        case "clear-night":
            self = .clearNight
        case "cloudy":
            self = .cloudy
        case "hail":
            self = .hail
        case "partly-cloudy-day":
            self = .partlyCloudyDay
        case "partly-cloudy-night":
            self = .partlyCloudyNight
        case "rain":
            self = .rain
        case "sleet":
            self = .sleet
        case "wind":
            self = .wind
        case "snow":
            self = .snow
        case "thunderstorm":
            self = .thunderstorm
        case "tornado":
            self = .tornado
        default:
            self = .unpredicted
        }
    }
}

extension WeatherIconManager{
    var image: UIImage{
        guard let img = UIImage(named: self.rawValue) else {
            return UIImage(named: "unpredicted-icon")!
        }
        return img
    }
}
