//
//  WeatherModel.swift
//  Clima
//
//  Created by Daegeon Choi on 2020/04/28.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionId: Int
    let temperature: Double
    
    var temperatureString: String{
        return String.init(format: "%.1f", temperature)
    }
    
    // computed property
    var conditionName: String {
        // docs https://openweathermap.org/weather-conditions
        switch conditionId/100 {
        case 2:
          return R.string.localizable.bolt()
        case 3:
            return R.string.localizable.drizzle()
        case 5:
            return R.string.localizable.rain()
        case 6:
            return R.string.localizable.snow()
        case 7:
            return R.string.localizable.fog()
        case 8:
            if conditionId == 800 {
              return R.string.localizable.sun()
            } else {
                return R.string.localizable.bolt()
            }
        default:
          return R.string.localizable.cloud()
        }
    }
    
}
