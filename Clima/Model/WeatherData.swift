//
//  WeatherData.swift
//  Clima
//
//  Created by Peter Lewis on 04/10/2022.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    var id: Int
}

