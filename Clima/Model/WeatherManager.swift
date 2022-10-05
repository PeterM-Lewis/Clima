//
//  WeatherManager.swift
//  Clima
//
//  Created by Peter Lewis on 04/10/2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateUI(_ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}
struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=f910d6d4eee9a442c8a152801d5ac68b&units=metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = parseData(safeData) {
                        delegate?.didUpdateUI(weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseData(_ data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let city = decodedData.name
            let temp = decodedData.main.temp
            
            let weather = WeatherModel(cityName: city, conditionID: id, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }
}
