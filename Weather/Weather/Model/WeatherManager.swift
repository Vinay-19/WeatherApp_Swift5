//
//  WeatherManager.swift
//  Weather
//
//  Created by Dev on 2022-06-20.
//
//Passing data to WeatherViewController, we can use protocols and delegates.

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
   func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
   func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=268d9a86b9e718a4aae78a2b7578449b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    
    // fetch weather using city name
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    // fetch weather based on current location
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //print(error)
                    return
                }
                if let safeData = data {
                  
                    if let weather = self.parseJSON(safeData) {
                       self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp) // object of Weather Model struct
            print(weather.conditionName)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
        
    }
    
    

