//
//  CovidData.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

struct CovidData: Codable{
    let Countries: [Countries]
    
    func returnCountriesTotal() -> Int{
        return Countries.count
    }
}

struct Countries: Codable{
    let Country: String
    let CountryCode: String
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int
}


