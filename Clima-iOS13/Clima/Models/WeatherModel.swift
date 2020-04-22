//
//  WeatherModel.swift
//  Clima
//
//  Created by Paulo C F Borges on 4/22/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var tempString: String{
        return String(format:"%.1f", temperature)
    }

    var conditionName: String {
        switch conditionId {
        case 200..<233:
            return "cloud.bolt"
        case 300..<322:
            return "cloud.drizzle"
        case 500..<532:
            return "cloud.rain"
        case 600..<623:
            return "cloud.snow"
        case 700..<781:
            return "cloud.fog"
        case 800..<832:
            return "sun.max"
        default:
            return "cloud"
        }
    }

}
