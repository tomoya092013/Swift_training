//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchField: UITextField!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var jokeField: UITextView!
  @IBOutlet weak var jokeButton: UIButton!
  
  //MARK: Properties
  var weatherManager = WeatherDataManager()
  let locationManager = CLLocationManager()
	let commonApi = CommonApi()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    searchField.delegate = self
    jokeButton.setTitle("Dad Joke", for: .normal)
  }
}

//MARK:- TextField extension
extension WeatherViewController: UITextFieldDelegate {
  
  @IBAction func searchBtnClicked(_ sender: UIButton) {
    searchField.endEditing(true)    //dismiss keyboard
    print(searchField.text!)
    searchWeather()
  }
  
  func changeBackgroundImage(_ cityName: String){
    if cityName == "Tokyo" {
      backgroundImage.image = UIImage(named: "AppIcon")
    } else {
      backgroundImage.image = UIImage(named: "background")
    }
  }
  
  func searchWeather(){
    guard let cityName = searchField.text,
          let url = URL(string: weatherManager.createFetchUrl(cityName))
    			else { return }
    
    commonApi.getRequest(url: url, type: WeatherData.self) { (weatherData: WeatherData) in
      DispatchQueue.main.sync {
        let weatherModel = WeatherModel(cityName: weatherData.name, conditionId: weatherData.weather[0].id, temperature: weatherData.main.temp)
        let conditionName = weatherModel.conditionName
        let cityName = weatherModel.cityName
        self.temperatureLabel.text = weatherModel.temperatureString
        self.conditionImageView.image = UIImage(systemName: conditionName)
        self.changeBackgroundImage(cityName)}
    } failedWithError: { (error) in
      print(error)
    }
	}
  
  // when keyboard return clicked
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchField.endEditing(true)    //dismiss keyboard
    print(searchField.text!)
    searchWeather()
    return true
  }
  
  // when textfield deselected
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
    if textField.text != "" {
      return true
    }else{
      textField.placeholder = "Type something here"
      return false            // check if city name is valid
    }
  }
  
  // when textfield stop editing (keyboard dismissed)
  func textFieldDidEndEditing(_ textField: UITextField) {
//            searchField.text = ""   // clear textField
  }
  
  @IBAction func jokeButton(_ sender: UIButton) {
    guard let url = URL(string: "https://icanhazdadjoke.com/") else { return }
    commonApi.getRequest(url: url, type: JokeData.self) { (jokeData: JokeData) in
      DispatchQueue.main.sync {
        let jokeModel = JokeModel(joke: jokeData.joke)
        self.jokeField.text = jokeModel.joke
      }
    } failedWithError: { (error) in
      print(error)
    }
  }
}

// MARK:- CLLocation
extension WeatherViewController: CLLocationManagerDelegate {
  
  @IBAction func locationButtonClicked(_ sender: UIButton) {
    // Get permission
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    let lat = location.coordinate.latitude
    let lon = location.coordinate.longitude
    let createdUrl = weatherManager.createFetchUrl(lat, lon)
    if let url = URL(string: createdUrl) {
      commonApi.getRequest(url: url, type: WeatherData.self) { (weatherData: WeatherData) in
        print(weatherData)
      } failedWithError: { (error) in
        print(error)
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
