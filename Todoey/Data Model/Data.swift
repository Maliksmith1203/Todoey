//
//  Data.swift
//  Todoey
//
//  Created by Malik Smith on 8/12/19.
//  Copyright © 2019 Malik Smith. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
   @objc dynamic var name:String = ""
   @objc dynamic var age: Int = 0
}
