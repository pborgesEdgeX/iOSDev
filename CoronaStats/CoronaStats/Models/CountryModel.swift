//
//  CountryModel.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/23/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

struct CountryModel{
    let country: [String]
    
    init(country: [String]) {
        self.country = country
    }
    
    func returnCountryTotal() -> Int{
        return self.country.count
    }
}
