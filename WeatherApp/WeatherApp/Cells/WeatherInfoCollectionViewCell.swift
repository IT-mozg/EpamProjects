//
//  WeatherInfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by Vlad on 6/5/19.
//  Copyright © 2019 Vlad Tkachuk. All rights reserved.
//

import UIKit

class WeatherInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageVIew: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    func setupCell(with weather: CurrentWeather){
        timeLabel.text = weather.timeString
        iconImageVIew.image = weather.icon
        temperatureLabel.text = weather.temperatureString
        humidityLabel.text = weather.humidityString
        pressureLabel.text = weather.pressureString
        weatherStatusLabel.text = weather.precipType
    }
}
