//
//  Category.swift
//  Todoey
//
//  Created by Paulo C F Borges on 5/13/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var backgroundColor: String?
    let items = List<Item>()
}
