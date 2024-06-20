//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

@available(iOS 15.0, *)
class WeatherViewController: UIViewController {
  
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchField: UITextField!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var jokeField: UITextView!
  @IBOutlet weak var jokeButton: UIButton!
  @IBOutlet weak var favoriteButton: UIButton!
  
  //MARK: Properties
  var weatherManager = WeatherDataManager()
  let locationManager = CLLocationManager()
  let commonApi = CommonApi()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    searchField.delegate = self
    jokeButton.setTitle(R.string.localizable.dadJoke(), for: .normal)
    favoriteButton.setTitle(R.string.localizable.favorite(), for: .normal)
    favoriteButton.setTitleColor(R.color.link(), for: .normal)
    title = R.string.localizable.weatherTitle()
    navigationItem.backBarButtonItem = UIBarButtonItem(title:  R.string.localizable.nonTitle(), style:  .plain, target: nil,action: nil)
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = R.color.clear()
    appearance.shadowColor = R.color.clear()
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance

  }
}

//MARK:- TextField extension
@available(iOS 15.0, *)
extension WeatherViewController: UITextFieldDelegate {
  
  @IBAction func searchBtnClicked(_ sender: UIButton) {
    searchField.endEditing(true)    //dismiss keyboard
    print(searchField.text!)
    searchWeather()
  }
  
  func changeBackgroundImage(_ cityName: String){
    if cityName == R.string.localizable.changeBgCity() {
      backgroundImage.image = UIImage(named: "AppIcon")
    } else {
      backgroundImage.image = R.image.background()
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
      textField.placeholder = R.string.localizable.weatherPlaceholder()
      return false            // check if city name is valid
    }
  }
  
  // when textfield stop editing (keyboard dismissed)
  func textFieldDidEndEditing(_ textField: UITextField) {
//            searchField.text = ""   // clear textField
  }
  
  @IBAction func jokeButton(_ sender: UIButton) {
    guard let url = URL(string: R.string.localizable.jokeApi()) else { return }
    commonApi.getRequest(url: url, type: JokeData.self) { (jokeData: JokeData) in
      DispatchQueue.main.sync {
        let jokeModel = JokeModel(joke: jokeData.joke)
        self.jokeField.text = jokeModel.joke
      }
    } failedWithError: { (error) in
      print(error)
    }
  }
  
  @IBAction func favoriteButton(_ sender: UIButton) {
    let favoriteTable = FavoriteCityTableController()
    navigationController?.pushViewController(favoriteTable, animated: true)
  }
}

// MARK:- CLLocation
@available(iOS 15.0, *)
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
    guard let url = URL(string: createdUrl) else { return }
    commonApi.getRequest(url: url, type: WeatherData.self) { (weatherData: WeatherData) in
      print(weatherData)
    } failedWithError: { (error) in
      print(error)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
