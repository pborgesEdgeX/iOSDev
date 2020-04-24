//
//  Int+Extensions.swift
//  CoronaStats
//
//  Created by Paulo C F Borges on 4/24/20.
//  Copyright © 2020 Paulo C F Borges. All rights reserved.
//

import Foundation
extension Int{
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
