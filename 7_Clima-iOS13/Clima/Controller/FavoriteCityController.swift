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
  
  var weatherManager = WeatherDataManager()
  var commonApi = CommonApi()
  var outputUrl: URL?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .clear
    appearance.shadowColor = .clear
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.compactAppearance = appearance
    
    updateWeather(url: outputUrl!)
    
  }
  
  func updateWeather(url: URL) {
    guard let url = outputUrl else { return }
    commonApi.getRequest(url: url, type: WeatherData.self) { (weatherData: WeatherData) in
      DispatchQueue.main.sync {
        let weatherModel = WeatherModel(cityName: weatherData.name, conditionId: weatherData.weather[0].id, temperature: weatherData.main.temp)
        let conditionName = weatherModel.conditionName
        self.cityLavel.text = weatherModel.cityName
        self.temperatureLabel.text = weatherModel.temperatureString
        self.conditionImageView.image = UIImage(systemName: conditionName)
        self.title = weatherModel.cityName}
    } failedWithError: { (error) in
      print(error)
    }
  }
}
