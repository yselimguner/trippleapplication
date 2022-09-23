//
//  WeatherViewController.swift
//  TripleApp
//
//  Created by Yavuz Güner on 22.09.2022.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController,UITextFieldDelegate, WeatherManagerDelegate {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel){
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            print(weather.temperature)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchTextField.endEditing(true)
    }
}
    extension WeatherViewController:UITextViewDelegate{
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true) //Burada işimiz bitince klavye kapatıyor
            return true
        }
        
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { //klavyeyi kapattığını anladığı anda bu fonksiton devreye girecek
            if textField.text != ""{
                return true
            } else {
                textField.placeholder = "Type something here"
                return false
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            if let city = searchTextField.text{
                weatherManager.fetchWeather(cityName: city)
            }
            
            searchTextField.text = "" //Textfield ile işimiz bitince içini bıoşaltıyor
        }
    }

    //MARK: -CLLocationManagerDelegate
    extension WeatherViewController:CLLocationManagerDelegate{
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last{
                locationManager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fetchWeather(longitude:lon, latitude:lat)
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    }
