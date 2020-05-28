//
//  Country.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 5/24/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation
import RealmSwift

class Country: Object {
    @objc dynamic var country: String = ""
    @objc dynamic var countryCode: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var NewConfirmed: Int = 0
    @objc dynamic var totalConfirmed: Int = 0
    @objc dynamic var NewDeaths: Int = 0
    @objc dynamic var totalDeaths: Int = 0
    @objc dynamic var NewRecovered: Int = 0
    @objc dynamic var totalRecovered: Int = 0
    @objc dynamic var date: String = ""
    
}
