//
//  Category.swift
//  Todoey
//
//  Created by Malik Smith on 8/12/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import Foundation
import RealmSwift


class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
