//
//  Data.swift
//
//  Created by Masato Sawada on 2022/11/12.
//

import Foundation
import RealmSwift

class RecordTemp: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var time: Double = 0.0
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
 
}
