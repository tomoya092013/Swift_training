//
//  WeatherDataManager.swift
//  Clima
//
//  Created by Daegeon Choi on 2020/04/15.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//MARK: DataManager struct
struct WeatherDataManager{
  let baseURL = R.string.localizable.weatherApi()
    //MARK:- fetchWeather
    func createFetchUrl(_ city: String) -> String {
        let completeURL = "\(baseURL)&q=\(city)"
        return completeURL
    }
    
    func createFetchUrl(_ latitude: Double, _ longitude: Double) -> String {
        let completeURL = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        return completeURL
    }
}

