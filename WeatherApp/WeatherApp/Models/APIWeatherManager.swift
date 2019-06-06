//
//  APIWeatherManager.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

class APIWeatherManager: APIManager{
    let apiKey: String
    var sessionConfiguration: URLSessionConfiguration
    lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    init(apiKey: String, sessionConfiguration: URLSessionConfiguration){
        self.apiKey = apiKey
        self.sessionConfiguration = sessionConfiguration
    }

    convenience init(apiKey: String){
        self.init(apiKey: apiKey, sessionConfiguration: URLSessionConfiguration.default)
    }
    
    func fetchWeather(with coords: Coordinates, time interval: WeatherTime, completionHandler: @escaping ([APIResult<CurrentWeather>]) -> Void){
        let request = ForecastType.current(apiKey: apiKey, coords: coords).reguest
        fetch(request: request, parse: { (json) -> [CurrentWeather]? in
            return interval.getParsedWeather(with: json)
        }, completionHandler: completionHandler)
    }
    
    
    
//    func getCurrentWeather(with request: URLRequest, and coordinates: Coordinates) -> CurrentWeather{
//        fetch(request: request, parse: { (json) -> CurrentWeather? in
//
//        }, completionHandler: <#T##(APIResult<T>) -> Void#>)
//    }
//
//    func getDailyWeather
    
}
