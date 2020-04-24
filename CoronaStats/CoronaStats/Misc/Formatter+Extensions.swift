//
//  Formatter+Extensions.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/24/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}
