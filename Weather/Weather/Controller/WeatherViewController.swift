//
//  WeatherViewController.swift
//  Weather
//
//  Created by Dev on 2022-06-19.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
  
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    // Below Function will be triggered when "go/return" button on keyword is pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true) // This endEditing will dismiss the keyword from the screen.
        return true
    }
    
    //Below function will be triggered as soon as any of the text field on the screen is done editing.
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
        
    }
    
    
//    func callWeatherApi() {
//
//        //Step 1 : Creating a URL
//        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=268d9a86b9e718a4aae78a2b7578449b&units=metric"
//
//        let urlString = "\(weatherURL)&q=windsor"
//        performRequest(with: urlString)
//
//    }
    
//    func performRequest(with urlString: String) {
//
//        //Step 2 : Create a URLSession
//        if let url = URL(string: urlString) {
//            let session = URLSession(configuration: .default)
//        //Step 3 : Give the session a task
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if error != nil {
//                    //self.delegate?.didFailWithError(error: error!)
//                    print(error)
//                    return
//                }
//                if let safeData = data {
////                    if let weather = self.parseJSON(safeData) {
//                       // self.delegate?.didUpdateWeather(self, weather: weather)
//
//                        let decoder = JSONDecoder()
//                        do {
//                            let decodedData = try decoder.decode(WeatherData.self, from: data!)
//                            let id = decodedData.weather[0].id
//                            let temp = decodedData.main.temp
//                            let name = decodedData.name
//
//                            //let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
//                          //  return weather
//
//                        } catch {
//                          //  delegate?.didFailWithError(error: error)
//                            print(error)
////                            return nil
//                        }
//
//
//
//                   // }
//                }
//            }
//            // Step 4 : Start the task
//            task.resume()
//        }
//    }
    
    
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        print("got location")
        locationManager.requestLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
