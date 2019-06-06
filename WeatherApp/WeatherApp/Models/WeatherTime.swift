//
//  WeatherTime.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum WeatherTime: String{
    case current = "current"
    case minutely = "minutely"
    case hourly = "hourly"
    case daily = "daily"
    
    func getJSONSubType(json: [String: AnyObject]) -> [String : AnyObject]{
        return json[self.rawValue] as! [String : AnyObject]
    }
    
    func getParsedWeather(with json: [String: AnyObject]) -> [CurrentWeather]?{
        let json = getJSONSubType(json: json)
        guard let weatherData = json["data"] as? [[String: AnyObject]] else{
            guard let current = CurrentWeather(json: json, weatherTime: self) else{
                return nil
            }
            return [current]
        }
        var weathers = [CurrentWeather]()
        for json in weatherData{
            if let current = CurrentWeather(json: json, weatherTime: self){
                weathers.append(current)
            }
        }
        return weathers
    }
}
