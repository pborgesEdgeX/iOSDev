//
//  CovidModel.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

struct CovidModel{
    let NewConfirmed: String
    let TotalConfirmed: String
    let NewDeaths: String
    let TotalDeaths: String
    let NewRecovered: String
    var TotalRecovered: String
    let countryName: String
    
    init(newConfirmed: Int, totalConfirmed: Int, newDeaths: Int, totalDeaths: Int, newRecovered: Int, totalRecovered: Int, countryName: String) {
        
        self.NewConfirmed = newConfirmed.formattedWithSeparator
        self.TotalConfirmed = totalConfirmed.formattedWithSeparator
        self.NewDeaths = newDeaths.formattedWithSeparator
        self.TotalDeaths = totalDeaths.formattedWithSeparator
        self.NewRecovered = newRecovered.formattedWithSeparator
        self.TotalRecovered = totalRecovered.formattedWithSeparator
        self.countryName = countryName
    }
    
    
}
