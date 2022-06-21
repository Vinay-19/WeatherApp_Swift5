//
//  WeatherData.swift
//  Weather
//
//  Created by Dev on 2022-06-20.
//

import Foundation

struct WeatherData: Codable {
    
    let name: String
    
    let main: Main
    
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable{
    let description: String
    let id: Int
}


