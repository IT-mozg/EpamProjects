//
//  ForecastType.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum ForecastType: FinalURL{
    
    case current(apiKey: String, coords: Coordinates)
    case timeInterval(apiKey: String, coords: Coordinates, time: String)
    case parameters(apiKey: String, coords: Coordinates, params: String)
    case timeWithParams(apiKey: String, coords: Coordinates, time:String, params: String)
    
    var base: URL{
        return URL(string: "https://api.darksky.net/")!
    }
    
    var path: String{
        switch self {
        case .current(let apiKey, let coords):
            return getBaseStringPath(apiKey: apiKey, coords: coords)
        case .timeInterval(let apiKey, let coords, let time):
            return "\(getBaseStringPath(apiKey: apiKey, coords: coords)),\(time))"
        case .parameters(let apiKey, let coords, let params):
            return "\(getBaseStringPath(apiKey: apiKey, coords: coords))?\(params))"
        case .timeWithParams(let apiKey, let coords, let time, let params):
            return "\(getBaseStringPath(apiKey: apiKey, coords: coords)),\(time)?\(params))"
        }
    }
    
    private func getBaseStringPath(apiKey: String, coords: Coordinates) -> String{
        return "forecast/\(apiKey)/\(coords.latitude),\(coords.longitude)"
    }
    
    var reguest: URLRequest{
        let url = URL(string: path, relativeTo: base)!
        return URLRequest(url: url)
    }
    
}
