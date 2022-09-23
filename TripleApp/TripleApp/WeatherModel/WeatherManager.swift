//
//  WeatherManager.swift
//  TripleApp
//
//  Created by Yavuz Güner on 22.09.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6059f17eac08a359f4bad36e7eb1f9cc"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName:String ){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
        print(urlString)
    }
    
    func fetchWeather(longitude : CLLocationDegrees, latitude : CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
        print(urlString)
    }
    
    func performRequest(with  urlString: String ){
        
        //1.Create URL
        
        if let url = URL(string: urlString) {
            //2.Create URLSession
            
            let session = URLSession(configuration: .default)
            
            //3.Give URLSession a task
            
            let task = session.dataTask(with: url) { (data, response, error)  in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                      self.delegate?.didUpdateWeather(self , weather: weather)
                    }
                }
            }
            //4.Start the task.
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temperature)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
