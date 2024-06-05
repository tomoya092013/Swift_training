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
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4e415e4ab2aaed09e04d8419beedee19&units=metric"
    
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

