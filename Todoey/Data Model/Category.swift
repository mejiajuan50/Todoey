//
//  Category.swift
//  Todoey
//
//  Created by Juan Mejia on 9/20/18.
//  Copyright © 2018 Juan Mejia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
