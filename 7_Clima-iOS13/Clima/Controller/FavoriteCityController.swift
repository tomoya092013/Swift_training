//
//  FavoriteCityController.swift
//  Clima
//
//  Created by 根岸智也 on 2024/06/09.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class FavoriteCityController: UIViewController {
  
  @IBOutlet weak var StackView: UIStackView!
  @IBOutlet weak var cityLavel: UILabel!
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  
  var commonApi = CommonApi()
  var apiResult: WeatherData
  
  init(weatherData: WeatherData) {
    self.apiResult = weatherData
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    
    fatalError(R.string.localizable.fatalError())
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = R.color.clear()
    appearance.shadowColor = R.color.clear()
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
    
    setWeatherData(weatherData: apiResult)
  }
    
  func setWeatherData(weatherData: WeatherData) {
    let weatherModel = WeatherModel(cityName: weatherData.name, conditionId: weatherData.weather[0].id, temperature: weatherData.main.temp)
    let conditionName = weatherModel.conditionName
    self.cityLavel.text = weatherModel.cityName
    self.temperatureLabel.text = weatherModel.temperatureString
    self.conditionImageView.image = UIImage(systemName: conditionName)
    self.title = weatherModel.cityName
  }
}
