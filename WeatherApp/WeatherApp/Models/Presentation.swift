//
//  Presentation.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import Foundation

enum DataType{
    case text(String?)
    case weather([CurrentWeather]?)
}

enum TableCellType: String{
    case cityName
    case hourlyWeather
    case dailyWeather
    case refresh
}

struct Presentation {
    let cellType: TableCellType
    let dataType: DataType
}
